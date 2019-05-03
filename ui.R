require(shiny)
require(visNetwork)
data <-
  read.csv("./message-graph.csv",
           header = F,
           stringsAsFactors = F)
names(data) <- c("api", "from", "to", "value")
data$title <- data$value
apis <- unique(c(data$api))


fluidPage(
  theme = "bootstrap.css",
  tags$head(
    tags$style(HTML("
                    @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
                    
                    h1 {
                    font-family: 'Lobster', cursive;
                    font-weight: 500;
                    line-height: 1.1;
                    } 
                    ")
    )
    ),
  headerPanel("Message Graph of senseID LOG"), 
  tags$head(
    # tags$script(src = 'https://code.jquery.com/jquery-1.11.1.min.js')
    includeScript("./json-viewer/jquery.json-viewer.js"),
    includeCSS("./json-viewer/jquery.json-viewer.css")
    # tags$script(src ="json-viewer/jquery.json-viewer.js"),
    # tags$link( href="json-viewer/jquery.json-viewer.css", rel="stylesheet")
    
  ),
  
  fluidRow(
    column(
      4,
      wellPanel(
        selectInput("request_path", "request_path", choices = apis),
        checkboxInput("schema", "show schema?", FALSE)
      ),
      hr(),
      conditionalPanel(
        condition = "input.schema == true",
        HTML("<b>schemas of this message</b>")
      ),
      conditionalPanel(
        condition = "input.schema == true",
        HTML(
          "
          <div style='height:500px;overflow:scroll;overflow-x:hidden;overflow-y:scroll;'>
          <pre id='json-render' style='height:500px;'></pre>
          </div>
          "
        )
      )
    ),
    
    column(
      8,
      visNetworkOutput("network", height = "800px"),
      verbatimTextOutput("sample")
    )
    
      ),
  HTML(
    "
    <script type='text/javascript'>
      $('#sample').bind('DOMSubtreeModified',function(){
        try {
          var v = eval($('#sample').text());
        }
        catch (error) {
          // return alert('Cannot eval JSON: ' + error +$('#sample').text());
        }
        $('#json-render').jsonViewer(v, {
          collapsed: false,
          rootCollapsable: false,
          withQuotes: false,
          withLinks: false
        });
        
      })
    </script>
    <style type='text/css'>
      #sample {
        visibility:hidden;
      }
    </style>"
  )
  )

