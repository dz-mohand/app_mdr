library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(sidebarMenu(
    menuItem("Table à blague", tabName = "dashboard"),
    menuItem("Agenda", tabName = "rawdata"),
    menuItem("Chapeau l'artiste !", tabName = "chapeau"),
    menuItem("Un scenario ?", tabName = "scenario"),
    menuItem("Bar à idée", tabName = "bar_idee")
    
    
    
  )),
  dashboardBody(
    tabItems(
      tabItem("dashboard",
              fluidRow(
                box(
                  textInput("titre_bl", label = h3("Le titre de ta blague"), value = "un peu d'originalité merde !"),
                  textInput("contenu_bl", label = h3("ta blague .. "), value = "Fais moi rire .."),
                  actionButton("go", "Go"),width = 12
                ),
                #box(
                  #tableOutput("fil_actualite")
                #),
                  uiOutput("nlp_sentences_tree")
                
                )
              
          ),
      tabItem("rawdata",
              fluidRow(
                box(
                  timevisOutput("mytime"),
                  textInput("label_dt", label = h3("Je fais quoi le ?"), value = "Je fais quoi.. ? "),
                  dateInput("date_deb", label = h3("Date de début"), value = "2018-01-01"),
                  dateInput("date_fin", label = h3("Date de fin"), value = "2018-01-01"),
                  actionButton("btn", "Add item and center"), width = 4, height = NULL
                ),
                box(
                  fullcalendar(data5), width = 8, height = NULL
                )
              )
      ),tabItem("chapeau",
                
                 fluidRow(
                  infoBoxOutput("spectacle_nbr_res"),
                  infoBoxOutput("spectacle_count"),
                  infoBoxOutput("approvalBox")
                ), 
                box(
                    plotlyOutput("plot"), width = 6, height = NULL
                  ),
                box(
                  plotlyOutput("plot_res_par_site"), width = 6, height = NULL
                ),
                box(
                  orderInput('source', 'Site de reservation', items = c("Billet reduc","site reservation","reservation en ligne","tic tac"),
                             as_source = TRUE, connect = 'dest'),
                  orderInput('dest', 'Dans le chapeau', items = NULL, placeholder = 'Drag items here...', item_class = 'info')
                  #verbatimTextOutput('order')
                  
                  
                )
    
  ),tabItem("scenario"
            )
            
  ),tabItem("bar_idee"
            
  )
)

)
