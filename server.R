require(shiny)
require(visNetwork)
require(jsonify)
require(jsonlite)
require(stringr)
 
data <-
  read.csv("./message-graph.csv",
           header = F,
           stringsAsFactors = F)
names(data) <- c("api", "from", "to", "value")
data$title <- data$value
apis <- unique(c(data$api))

 

schemas_df <- read.csv2("./schemas.csv", sep="\001", header = T, quote = "",  stringsAsFactors = FALSE, allowEscapes=T)
schemas_df$json = str_sub(schemas_df$sample, 2, str_length(schemas_df$sample)-1)


server <- function(input, output, session) {
  observe({
    active_path = input$request_path
    
    
    myDataSet <- data[data$api == active_path, ]
    messages <- unique(c(myDataSet$from, myDataSet$to))
    
    output$network <- renderVisNetwork({
      nodes <- data.frame(id = messages, label = messages)
      edges <- myDataSet
      visNetwork(nodes, edges, height = "100%", width = "100%") %>%
        visEdges(arrows = "to",
                 color = list(color = "lightblue", highlight = "red")) %>%
        visOptions(
          manipulation = TRUE,
          nodesIdSelection = TRUE,
          highlightNearest =  list(
            enabled = TRUE,
            degree = 2,
            hover = F
          )
        ) %>%
        visInteraction(hover = F)  %>%
        visPhysics(stabilization = TRUE) %>%
        visEvents(selectNode = "function(nodes) {
                  Shiny.onInputChange('current_node_id', nodes);
                  ;}")
  })


    output$sample <-  renderPrint({
      # (schemas_df$api==input$request_path&schemas_df$message==input$current_node_id$node)
      active_node = input$current_node_id$node 
      mySchema <- schemas_df[schemas_df$request_path==active_path&schemas_df$message==active_node, ] 
      json <- paste("[",paste(mySchema[, "json"], sep="", collapse = ","),"]") 
      mydf <- fromJSON(json) 
      toJSON(mydf, pretty=TRUE)
    })
  })
}
