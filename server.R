function(input, output, session) {

fields <- c("titre_bl", "contenu_bl")
fields_events <- c("label_dt", "date_deb","date_fin")


#ajout <- eventReactive(input$go, {
#  df1 <- as.data.frame(toString(input$titre_bl),toString(input$contenu_bl))  
#  saveData(df1)
#})

formData <- reactive({
  data1 <- sapply(fields, function(x) input[[x]])
  data1
})

formData_events <- reactive({
  data_events <-data.frame(input$label_dt,input$date_deb,input$date_fin)
  #data_events <- sapply(fields_events, input[[x]])
  data_events
})

output$mytime <- renderTimevis(timevis())
observeEvent(input$btn, {
  addItem("mytime", list(id = id, content = input$label_dt , start = input$date))
  centerItem("mytime", id)
})
# When the Submit button is clicked, save the form data
observeEvent(input$go, {
  saveData("mdr",formData())
})

observeEvent(input$btn, {
  saveData("events",formData_events())
})

fil_actualitee <- loadData("mdr")
events <- data.frame(loadData("events"))

output$fil_actualite <- renderTable({ as.data.frame(fil_actualitee)})

v <- list()
for (i in 1:length(fil_actualitee[[1]])){
  v[[i]] <- box(title = fil_actualitee[[1]][i], width = 4, background = "light-blue", fil_actualitee[[2]][i])
}
output$nlp_sentences_tree <- renderUI(v)
#output$example <-   renderUI({
#  
#  x <- paste0("<div class=\"alert alert-dismissible alert-warning\">
#                          <button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button><h4 class=\"alert-heading\">", paste(fil_actualitee[1,2], collapse = "</h4><p class=\"mb-0\"><a href=\"#\" class=\"alert-link\"></a>.</p></div>"))
#  HTML(x)
#})


data5 = data.frame(title = events$input_label_dt,
                   start = events$input_date_deb,
                   end = events$input_date_fin)


output$plot <- renderPlotly({
  plot_ly(
  x = spectacle$date_spectacle,
  y = spectacle$nombre_reservation,
  name = "Reservation",
  type = "bar"
  )
  })

output$spectacle_nbr_res <- renderInfoBox({
  infoBox(
    "Nombre de reservations",spectacle_nbr_res$x,icon = icon("thumbs-up", lib = "glyphicon"),
    color = "yellow"
  )
})

output$spectacle_count <- renderInfoBox({
  infoBox(
    "Nombre de représentation",spectacle_count$n, icon = icon("list"),
    color = "purple"
  )
})
output$approvalBox <- renderInfoBox({
  infoBox(
    "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
    color = "yellow"
  ) 
})

output$plot_res_par_site <- renderPlotly({ 
  p <- spectacle %>%
    group_by(site_reservation) %>%
    summarize(count = n()) %>%
    plot_ly(labels = ~site_reservation, values = ~count) %>%
    add_pie(hole = 0.6) %>%
    layout(title = "DIstribution de la réservation par site",  showlegend = F,
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
})
output$order <- renderPrint({ print(input$dest_order) })
}
