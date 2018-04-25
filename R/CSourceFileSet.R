#' CSourceFileSet
#'
#' \code{CSourceFileSet} Sources a Corpus object from a FileSet object.
#'
#' @section Methods:
#'  \itemize{
#'   \item{\code{new(x, name = NULL)}}{Initializes an object of the CSourceFileSet class.}
#'   \item{\code{source()}}{Executes the process of sourcing the Corpus object.}
#'  }
#'
#' @param name Optional character vector indicating name for Corpus object.
#' @param x Character vector or a list of character vectors containing text.
#'
#' @examples
#' text <- c("The firm possesses unparalleled leverage in Washington,
#' thanks in part to its track record of funneling executives into
#' senior government posts. Even the Trump administration, which
#' rode a populist wave to electoral victory, is stocked with
#' Goldman alumni, including Treasury Secretary Steven Mnuchin and
#' the departing White House economic adviser Gary D. Cohn.",
#' "Goldman is also an adviser to many of America’s — and the
#' world’s — largest companies, ranging from stalwarts like Walt
#' Disney to upstarts like Uber.")
#'
#' corpus <- CSource$new(x = txt, name = "Goldman")$vector()
#'
#' @docType class
#' @author John James, \email{jjames@@datasciencesalon.org}
#' @family Corpus Source Classes
#' @export
CSourceFileSet <- R6::R6Class(
  classname = "CSourceFileSet",
  lock_objects = FALSE,
  lock_class = FALSE,
  inherit = CSource0,

  public = list(

    #-------------------------------------------------------------------------#
    #                       Instantiation Method                              #
    #-------------------------------------------------------------------------#
    initialize = function() {

      private$loadDependencies()
      invisible(self)
    },


    #-------------------------------------------------------------------------#
    #                          Execute Method                                 #
    #-------------------------------------------------------------------------#
    source = function(x, name = NULL) {

      # Validate text
      private$..params <- list()
      private$..params$classes$name <- list('x')
      private$..params$classes$objects <- list(x)
      private$..params$classes$valid <- list(c('FileSet'))
      v <- private$validator$validate(self)
      if (v$code == FALSE) {
        private$logR$log(method = 'source',
                         event = v$msg, level = "Error")
        stop()
      }

      if (!is.null(name)) name <- x$getName()
      corpus <- Corpus$new(name = name)

      # Obtain Files objects, create Document objects and add to Corpus
      files <- x$getFiles()
      for (i in 1:length(files)) {
        content <- f$read()
        name <- f$getName()
        doc <- Document$new(x = content, name = name)
        corpus$addDocument(doc)
      }

      event <- paste0("Corpus", corpus$getName(), " sourced from ",
                      "FileSet object ", x$getName(), ".")
      corpus$message(event = event)

      return(corpus)
    },
    #-------------------------------------------------------------------------#
    #                           Visitor Methods                               #
    #-------------------------------------------------------------------------#
    accept = function(visitor)  {
      visitor$csourceFileSet(self)
    }
  )
)