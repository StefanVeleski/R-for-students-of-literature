library(shiny)
library(tidyverse)
library(ggthemes)

Main_dataset <- read_csv("Main dataset.csv")

options(scipen=10000)
shinyApp(
    ui <- fluidPage(
        titlePanel("Distribution of the present day popularity and critical prestige of late Victorian novels"),
        plotOutput("plot"),
        actionButton("button", "Next plot"),
    ),
    
    server <- function(input, output, session) {
        whichplot <- reactiveVal(TRUE)
        plot1 <- ggplot(Main_dataset, aes(x = Rank1, y = Ratings, label = Title)) +
            geom_point(alpha = 0.8, size = 3, color = "gray48") +
            scale_x_log10() +
            labs(
                title = "Distribution of present day popularity (log)",
                x = "Rank (log)",
                y = "Number of Goodreads Ratings"
            ) +
            theme_classic()
        
        plot2 <- ggplot(Main_dataset, aes(x = Rank2, y = Syllabi, label = Title)) +
            geom_point(alpha = 0.8, size = 3, color = "gray48") +
            scale_x_log10() +
            labs(
                title = "Distribution of critical prestige (log)",
                x = "Rank (log)",
                y = "Number of Open Syllabus entries"
            ) +
            theme_classic()
        
        
        observeEvent(input$button, {
            whichplot(!whichplot())
        })
        
        which_graph <- reactive({
            if (whichplot()) {
                plot1
            } else {
                plot2
            }
        })
        
        output$plot <- renderPlot({   
            which_graph()
        })
    }
)
