require(shiny)
require(visNetwork)
require(jsonify)
data <-
  read.csv("./message-graph.csv",
           header = F,
           stringsAsFactors = F)
names(data) <- c("api", "from", "to", "value")
data$title <- data$value
apis <- unique(c(data$api))

server <- function(input, output, session) {
  observe({
    myDataSet <- data[data$api == input$request_path, ]
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
        visInteraction(hover = TRUE)  %>%
        visPhysics(stabilization = TRUE) %>%
        visEvents(hoverNode = "function(nodes) {
                  Shiny.onInputChange('current_node_id', nodes);
                  ;}")
  })
    output$sample <-  renderPrint({
      df <- data.frame(id = c("name"),
                       val = input$current_node_id$node)
      js <- to_json(df)
      js
    })
  })
}
