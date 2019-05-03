require(shiny)
require(visNetwork)
require(jsonify)
require(jsonlite)
data <-
  read.csv("./message-graph.csv",
           header = F,
           stringsAsFactors = F)
names(data) <- c("api", "from", "to", "value")
data$title <- data$value
apis <- unique(c(data$api))

raw_df <- 
  data.frame(
    id   = 1:2,
    json = 
      c(
        '{"user": "xyz2", "weightmap": {"P1":100,"P2":0}, "domains": ["a2","b2"]}', 
        '{"user": "xyz1", "weightmap": {"P1":0,"P2":100}, "domains": ["a1","b1"]}'
      ), 
    stringsAsFactors = FALSE
  )

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
      json <- paste("[",paste(raw_df$json, sep="", collapse = ","),"]")
      mydf <- fromJSON(json)
      toJSON(mydf, pretty=TRUE)
    })
  })
}
