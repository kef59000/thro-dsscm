
predictive_analytics_UI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(width=12, verbatimTextOutput(ns("report_info")))),
    fluidRow(
      box(title="Controls", status='primary', width=12, collapsible = TRUE, collapsed = FALSE,
          column(width=2, selectizeInput(ns("KArt"), label="Kunden: Art", choices = NULL, multiple=TRUE)),
          column(width=2, selectizeInput(ns("KGrp"), label="Kunden: Gruppe", choices = NULL, multiple=TRUE)),
          column(width=2, selectizeInput(ns("KTyp"), label="Kunden: Typ", choices = NULL, multiple=TRUE)),
          column(width=2, selectizeInput(ns("Forecast"), label="Forecast Method", choices = c("Expo-1", "Expo-2"), selected ="Expo-1", multiple=FALSE)))),
    fluidRow(
      uiOutput(ns("box_tbl")),
      uiOutput(ns("box_forecast_1"))),
    fluidRow(
      uiOutput(ns("box_forecast_2")))
    )
}


predictive_analytics <- function(input, output, session) {
  
  updateSelectizeInput(session, "KArt", choices=unique(shpm$Kart), server=TRUE)
  updateSelectizeInput(session, "KGrp", choices=unique(shpm$Kgruppe), server=TRUE)
  updateSelectizeInput(session, "KTyp", choices=unique(shpm$Ktyp), server=TRUE)
  
  
  output$report_info <- renderText({
    HTML("This report is doing customer demand forecasts.")
  })
  
  
  selected <- reactiveValues(KArt = NULL,
                             KGrp = NULL,
                             KTyp = NULL)
  
  filtered <- reactiveValues(KArt = unique(shpm$Kart),
                             KGrp = unique(shpm$Kgruppe),
                             KTyp = unique(shpm$Ktyp))
  
  
  observeEvent(eventExpr = input$KArt, ignoreNULL = FALSE, ignoreInit = TRUE, {
    selected$KArt <- input$KArt
    filtered$KArt <- if(is.null(selected$KArt)) unique(shpm$Kart) else selected$KArt
  })
  
  observeEvent(eventExpr = input$KGrp, ignoreNULL = FALSE, ignoreInit = TRUE, {
    selected$KGrp <- input$KGrp
    filtered$KGrp <- if(is.null(selected$KGrp)) unique(shpm$Kgruppe) else selected$KGrp
  })
  
  observeEvent(eventExpr = input$KTyp, ignoreNULL = FALSE, ignoreInit = TRUE, {
    selected$KTyp <- input$KTyp
    filtered$KTyp <- if(is.null(selected$KTyp)) unique(shpm$Ktyp) else selected$KTyp
  })
  
  
  
  filtered_data <- reactive({
    temp <- shpm %>%
      filter(Kart %in% filtered$KArt, Kgruppe %in% filtered$KGrp, Ktyp %in% filtered$KTyp)
  })
  
  
  output$box_tbl <- renderUI({
    ns <- session$ns
    
    box(title="Shipment Data", status="primary", width=6,
        dataTableOutput(ns("table")))
  })
  
  
  output$table <- renderDataTable({
    
    temp <- filtered_data() %>%
      mutate(del_date = dmy_hms(Delivery_day)) %>%
      select(del_date, Plant, Kname, KPlz, Kort, Pallets, GWkg)
    
    DT::datatable(temp, filter='top', options=list(pageLength=5))
  })
  
  
  output$box_forecast_1 <- renderUI({
    ns <- session$ns
    
    box(title="Forecast 1", status="primary", width=6,
        plotOutput(ns("forecast_1")))
  })
  
  output$forecast_1 <- renderPlot({
    
    temp <- filtered_data() %>%
      mutate(week = week(dmy_hms(Delivery_day))) %>%
      group_by(week) %>%
      summarise(tons = sum(GWkg)/1000) %>%
      ungroup()
    
    anz_total <- temp %>% nrow()
    anz_train <- round(0.8 * anz_total)
    anz_test <- anz_total - anz_train
    
    train <- temp %>%
      select(tons) %>%
      slice(1:anz_train) %>%
      as.ts()
    
    fc_1 <- ses(train, h=anz_test)
    fc_2 <- holt(train, h=anz_test)
    # fc_3 <- forecast(ets(train, h=anz_test))
    # fc_4 <- forecast(auto.arima(train, h=anz_test))
    # fc_5 <- forecast(nnetar(train, h=anz_test))
    
    fc_sel <- switch (input$Forecast,
      "Expo-1" = fc_1,
      "Expo-2" = fc_2
    )
    
    autoplot(fc_sel) +
      autolayer(fc_sel$mean, series="Forecast")
  })
  
  
  output$box_forecast_2 <- renderUI({
    ns <- session$ns
    
    box(title="Forecast 2", status="primary", width=12,
        plotlyOutput(ns("forecast_2")))
  })
  
  
  output$forecast_2 <- renderPlotly({
    
    temp <- shpm %>%
      mutate(del_date = dmy_hms(Delivery_day)) %>%
      group_by(del_date) %>%
      summarise(sum_tons = sum(GWkg)/1000) %>%
      ungroup() %>%
      arrange(del_date) %>%
      mutate(week_day = weekdays(del_date))
    
    working_day <- seq(from=1, to=nrow(temp))
    
    temp_1 <- temp %>%
      cbind(working_day) %>%
      select(-del_date) %>%
      mutate(Di = ifelse(week_day == "Tuesday", 1, 0),
             Mi = ifelse(week_day == "Wednesday", 1, 0),
             Do = ifelse(week_day == "Thursday", 1, 0),
             Fr = ifelse(week_day == "Friday", 1, 0)) %>%
      select(1, 3:7)
    
    
    share_train <- 0.8
    
    set.seed(100)
    shpm_train_rows <- sample(1:nrow(temp_1), share_train * nrow(temp_1))
    shpm_TrainData <- temp_1[shpm_train_rows,]
    shpm_TestData <- temp_1[-shpm_train_rows,]
    
    
    mod_1 <- lm(data = shpm_TrainData, formula = sum_tons ~ working_day)
    res_1 <- predict(mod_1, shpm_TestData)
    
    mod_2 <- lm(data = shpm_TrainData, formula = sum_tons ~ working_day + Di + Mi + Do + Fr)
    res_2 <- predict(mod_2, shpm_TestData)
    
    mod_3 <- lm(data = shpm_TrainData, formula = sum_tons ~ Di + Mi + Do + Fr)
    res_3 <- predict(mod_3, shpm_TestData)
    
    
    inp_ens <- data.frame(cbind(y = shpm_TestData$sum_tons, res_1, res_2, res_3))
    mod_ens <- lm(data=inp_ens, formula = y ~ -1 + res_1 + res_2 + res_3)
    res_ens <- predict(mod_ens, inp_ens)
    
    actuals_preds <- data.frame(cbind(actuals = shpm_TestData$sum_tons, res_1, res_2, res_3, res_ens))
    mape <- mean(abs((actuals_preds$res_ens - actuals_preds$actuals)/actuals_preds$actuals))
    
    
    res <- data.frame(cbind(actuals = shpm_TestData$sum_tons, res_1, res_2, res_3, res_ens))
    xaxis <- seq(from=1, to =nrow(res))
    res <- cbind(xaxis, res)
    
    plot <- ggplot(data = res, aes(x=xaxis)) +
      geom_line(aes(y=actuals, colour="Actual"), linewidth=0.8) +
      geom_line(aes(y=res_1, colour="Model 1"), linewidth=0.8) +
      geom_line(aes(y=res_2, colour="Model 2"), linewidth=0.8) +
      geom_line(aes(y=res_3, colour="Model 3"), linewidth=0.8) +
      geom_line(aes(y=res_ens, colour="Ensemble"), linewidth=0.8) +
      labs(x = "Test Data: x", y = "Test Data: y") +
      scale_color_manual(name="Models",
                         values=c("red", "green", "blue", "orange", "purple"))
    
    
    plot %>% ggplotly()
  })
}