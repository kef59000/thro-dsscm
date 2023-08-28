
descriptive_analytics_UI <- function(id) {
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(width=12, verbatimTextOutput(ns("report_info")))),
    fluidRow(
      box(title="Controls", status='primary', width=12, collapsible = TRUE, collapsed = FALSE,
          column(width=2, selectizeInput(ns("KArt"), label="Kunden: Art", choices = NULL, multiple=TRUE)),
          column(width=2, selectizeInput(ns("KGrp"), label="Kunden: Gruppe", choices = NULL, multiple=TRUE)),
          column(width=2, selectizeInput(ns("KTyp"), label="Kunden: Typ", choices = NULL, multiple=TRUE)),
          column(width=3, uiOutput(ns("Bestellvolumen"))))),
    fluidRow(
      uiOutput(ns("box_map")),
      uiOutput(ns("box_pie"))),
    fluidRow(
      box(title="Customer Orders", status="primary", width=12,
          plotlyOutput(ns("histo")))
    )
  )
}



descriptive_analytics <- function(input, output, session) {
  
  # Reactive Variables ------------------------------------------------------

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
  
  

  # User Interface ----------------------------------------------------------
  output$report_info <- renderText({
    HTML("This report is showing my customer data.")
  })
  
  
  # Input Boxes
  updateSelectizeInput(session, "KArt", choices=unique(shpm$Kart), server=TRUE)
  updateSelectizeInput(session, "KGrp", choices=unique(shpm$Kgruppe), server=TRUE)
  updateSelectizeInput(session, "KTyp", choices=unique(shpm$Ktyp), server=TRUE)
  
  # Slider
  output$Bestellvolumen <- renderUI({
    ns <- session$ns
    
    temp <- shpm %>%
      group_by(customer_ID) %>%
      summarise(GWkg = sum(GWkg)/1000) %>%
      ungroup()
    
    gewicht_max <- round(max(temp$GWkg), digits=0)
    
    sliderInput(ns("sld_Bestellvolumen"), label="Bestellvolumen", min=0, max=gewicht_max, value=gewicht_max/2, step=100)
    
  })
  
  # Box: Map & Pie
  output$box_map <- renderUI({
    ns <- session$ns
    
    box(title="Customer Locations", status="primary", width=8,
        leafletOutput(ns("map")))
  })
  
  
  output$box_pie <- renderUI({
    ns <- session$ns
    
    box(title="Customer Orders", status="primary", width=4,
        plotlyOutput(ns("pie")))
  })
  
  
  # Data Preparation --------------------------------------------------------

  # Map
  map_data <- reactive({
    
    colorRange <- input$sld_Bestellvolumen
    colorRange[1] <- if(is.null(colorRange[1])) 0 else colorRange[1]
    
    temp <- shpm %>%
      filter(Kart %in% filtered$KArt, Kgruppe %in% filtered$KGrp, Ktyp %in% filtered$KTyp) %>%
      group_by(Kname, Kstrasse, KPlz, Kort, customer_Longitude, customer_Latitude) %>%
      summarise(sum_pallets = sum(Pallets), sum_gwkg = sum(GWkg)) %>%
      ungroup() %>%
      mutate(color_lbls = ifelse(sum_gwkg < colorRange[1], "green", "red"),
             popup_content = paste(sep='<br>',
                                   paste0('<b>', Kname, '</b>'), Kstrasse, KPlz, Kort,
                                   round(sum_gwkg, digits=0), round(sum_pallets, digits=0)))
  })
  
  
  output$map <- renderLeaflet({
    
    leaflet(data=shpm) %>%
      addProviderTiles(providers$OpenStreetMap.DE) %>%
      fitBounds(~min(customer_Longitude), ~min(customer_Latitude),
                ~max(customer_Longitude), ~max(customer_Latitude))
  })
  
  
  observe(
    leafletProxy("map", data=map_data()) %>%
      clearMarkers() %>%
      clearMarkerClusters() %>%
      addAwesomeMarkers(clusterOptions = markerClusterOptions(),
                        icon = awesomeIcons(markerColor = map_data()$color_lbls),
                        lng = ~customer_Longitude, lat = ~customer_Latitude,
                        popup = ~popup_content)
  )
  
  
  #Pie
  pie_data <- reactive({
    
    bounds <- input$map_bounds
    
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    temp <- shpm %>%
      filter(Kart %in% filtered$KArt, Kgruppe %in% filtered$KGrp, Ktyp %in% filtered$KTyp,
             customer_Latitude >= latRng[1], customer_Latitude <= latRng[2],
             customer_Longitude >= lngRng[1], customer_Longitude <= lngRng[2])
  })
  
  
  output$pie <- renderPlotly({
    
    temp <- pie_data() %>%
      group_by(Kart) %>%
      summarise(tons = sum(GWkg)/1000) %>%
      ungroup()
    
    
    plot_ly() %>%
      add_pie(data=temp, labels= ~Kart, values=~tons,
              name='Order Shares', rotation=90,
              hoverinfo='text', text=~paste0("Sendungsvolumen: ", format(round(tons, digits=0), big.mark='.', decimal.mark = ','))) %>%
      layout(title='', showlegend=TRUE)
  })
  
  
  output$histo <- renderPlotly({
    
    temp <- pie_data() %>%
      mutate(week = week(dmy_hms(Delivery_day))) %>%
      group_by(week) %>%
      summarise(tons = sum(GWkg)/1000) %>%
      ungroup()
    
    fit <- lm(data=temp, tons ~ week)
    
    plot_ly(x = ~week) %>%
      add_trace(data=temp, type='bar', y= ~tons,
                hoverinfo='text', text= ~paste0("Sendungsvolumen: ", format(round(tons, digits=0), big.mark='.', decimal.mark = ','))) %>%
      add_lines(y = fitted(fit), name = "Regression Line") %>%
      layout(title='', showlegend=TRUE)
    
  })
}
