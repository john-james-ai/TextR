#------------------------------------------------------------------------------#
#                                TextConfig                                    #
#------------------------------------------------------------------------------#
#' TextConfig
#'
#' \code{TextConfig} Class containing configuration for text pre-processing
#'
#' @docType class
#' @author John James, \email{jjames@@dataScienceSalon.org}
#' @export
TextConfig <- R6::R6Class(
  classname = "TextConfig",
  lock_objects = FALSE,
  lock_class = FALSE,
  inherit = Super,

  private = list(
    ..lowercase = FALSE,
    ..remove = list(
      stopwords = FALSE,
      punct = FALSE,
      numbers = FALSE,
      symbols  = FALSE,
      twitter = FALSE,
      url = FALSE,
      email = FALSE,
      profanity = FALSE
    ),
    ..replace = list(
      hyphen = FALSE,
      abbreviations = FALSE,
      slang = FALSE,
      backtick = FALSE,
      contractions = FALSE,
      curlyQuotes = FALSE,
      emoji = FALSE,
      emoticon = FALSE,
      kern = FALSE,
      numbers = FALSE,
      ordinal = FALSE,
      symbols = FALSE,
      wordElongation = FALSE,
      whiteSpace = FALSE
    ),
    ..add = list(
      commaSpace = FALSE
    ),
    ..abbreviations = character(),
    ..slang = character(),
    ..contractions = character(),
    ..profanity = character(),
    ..stopwords = character()
  ),


  public = list(
    #-------------------------------------------------------------------------#
    #                             Constructor                                 #
    #-------------------------------------------------------------------------#
    initialize = function() {
      private$loadServices(name = 'TextConfig')
      invisible(self)
    },

    getConfig = function() private,
    #-------------------------------------------------------------------------#
    #                     Load Reference Data: Abbreviations                  #
    #-------------------------------------------------------------------------#
    loadAbbreviations = function(x) {

      messageUser = function() {
        event <- paste0("TextConfig expects the abbreviations object to be ",
                        "a two-column data-frame with the abbreviation in ",
                        "the first column and the expanded form in the second. ",
                        "See ?", class(self)[1], " for further information.")
        private$logR$log(method = 'loadAbbreviations', event = event,
                         level = "Error")
        stop()
      }

      if (!class(x)[1] %in% c('data.frame', 'data.table')) messageUser()
      if (ncol(x) != 2) messageUser()
      private$..abbreviations <- x
      invisible(self)
    },
    getAbbreviations = function() private$..abbreviations,
    #-------------------------------------------------------------------------#
    #                     Load Reference Data: Slang                          #
    #-------------------------------------------------------------------------#
    loadSlang = function(x) {

      messageUser = function() {
        event <- paste0("TextConfig expects the slang object to be ",
                        "a two-column data-frame with the slang in ",
                        "the first column and the standard form in the second. ",
                        "See ?", class(self)[1], " for further information.")
        private$logR$log(method = 'loadSlang', event = event,
                         level = "Error")
        stop()
      }

      if (!class(x)[1] %in% c('data.frame', 'data.table')) messageUser()
      if (ncol(x) != 2) messageUser()
      private$..slang <- x
      invisible(self)
    },
    getSlang = function() private$..slang,
    #-------------------------------------------------------------------------#
    #                     Load Reference Data: Contractions                   #
    #-------------------------------------------------------------------------#
    loadContractions = function(x) {

      messageUser = function() {
        event <- paste0("TextConfig expects the contractions object to be ",
                        "a two-column data-frame with the contractions in ",
                        "the first column and the expanded form in the second. ",
                        "See ?", class(self)[1], " for further information.")
        private$logR$log(method = 'loadContractions', event = event,
                         level = "Error")
        stop()
      }

      if (!class(x)[1] %in% c('data.frame', 'data.table')) messageUser()
      if (ncol(x) != 2) messageUser()
      private$..contractions <- x
      invisible(self)
    },
    getContractions = function() private$..contractions,
    #-------------------------------------------------------------------------#
    #                     Load Reference Data: Profanity                      #
    #-------------------------------------------------------------------------#
    loadProfanity = function(x) {

      private$..params <- list()
      private$..params$classes$name <- list('x')
      private$..params$classes$objects <- list(x)
      private$..params$classes$valid <- list(c('character', 'list', 'data.frame'))
      v <- private$validator$validate(self)
      if (v$code == FALSE) {
        private$logR$log(method = 'loadProfanity', event = v$msg, level = "Error")
        stop()
      }
      private$..profanity <- x
      invisible(self)
    },
    getProfanity = function() private$..profanity,

    #-------------------------------------------------------------------------#
    #                     Load Reference Data: Stopwords                      #
    #-------------------------------------------------------------------------#
    loadStopwords = function(x) {

      private$..params <- list()
      private$..params$classes$name <- list('x')
      private$..params$classes$objects <- list(x)
      private$..params$classes$valid <- list(c('character', 'list', 'data.frame'))
      v <- private$validator$validate(self)
      if (v$code == FALSE) {
        private$logR$log(method = 'loadStopwords', event = v$msg, level = "Error")
        stop()
      }
      private$..stopwords <- x
      invisible(self)
    },
    getStopwords = function() private$..stopwords,
    #-------------------------------------------------------------------------#
    #                       Configuration Methods                             #
    #-------------------------------------------------------------------------#
    lowercase = function() {
      private$..lowercase <- TRUE
      invisible(self)
    },

    keepCase = function() {
      private$..lowercase <- FALSE
      invisible(self)
    },

    removeStopwords = function() {
      private$..remove$stopwords <- TRUE
      invisible(self)
    },

    keepStopwords = function() {
      private$..remove$stopwords <- FALSE
      invisible(self)
    },

    removePunct = function() {
      private$..remove$punct <- TRUE
      invisible(self)
    },

    keepPunct = function() {
      private$..remove$punct <- FALSE
      invisible(self)
    },

    removeNumbers = function()  {
      private$..remove$numbers <- TRUE
      invisible(self)
    },

    keepNumbers = function()  {
      private$..remove$numbers <- FALSE
      invisible(self)
    },

    removeSymbols = function() {
      private$..remove$symbols <- TRUE
      invisible(self)
    },

    keepSymbols = function() {
      private$..remove$symbols <- FALSE
      invisible(self)
    },

    removeTwitter = function() {
      private$..remove$twitter <- TRUE
      invisible(self)
    },

    keepTwitter = function() {
      private$..remove$twitter <- FALSE
      invisible(self)
    },

    removeURL = function() {
      private$..remove$url <- TRUE
      invisible(self)
    },

    keepURL = function() {
      private$..remove$url <- FALSE
      invisible(self)
    },

    removeEmail = function() {
      private$..remove$email <- TRUE
      invisible(self)
    },

    keepEmail = function() {
      private$..remove$email <- FALSE
      invisible(self)
    },

    removeProfanity = function(profanity = NLPLists::profanity) {
      private$..remove$profanity <- TRUE
      if (is.data.frame(profanity)) profanity <- profanity[,1]
      private$..profanity <- profanity
      invisible(self)
    },

    keepProfanity = function() {
      private$..remove$profanity <- FALSE
      invisible(self)
    },

    replaceHyphen = function() {
      private$..replace$hyphen <- TRUE
      invisible(self)
    },

    keepHyphen = function() {
      private$..replace$hyphen <- FALSE
      invisible(self)
    },

    replaceAbbreviations = function(abbreviations = NULL) {
      private$..replace$abbreviations <- TRUE
      private$..abbreviations <- abbreviations
      invisible(self)
    },

    keepAbbreviations = function() {
      private$..replace$abbreviations <- FALSE
      invisible(self)
    },

    replaceInternetSlang = function(slang = NLPLists::internetAbbreviations) {
      private$..replace$slang <- TRUE
      private$..slang <- slang
      invisible(self)
    },

    keepInternetSlang = function() {
      private$..replace$slang <- FALSE
      invisible(self)
    },

    replaceBacktick = function() {
      private$..replace$backtick <- TRUE
      invisible(self)
    },

    keepBacktick = function() {
      private$..replace$backtick <- FALSE
      invisible(self)
    },

    replaceContractions = function(contractions = NLPLists::contractions) {
      private$..replace$contractions <- TRUE
      private$..contractions <- contractions
      invisible(self)
    },

    keepContractions = function() {
      private$..replace$contractions <- FALSE
      invisible(self)
    },

    replaceCurlyQuotes = function() {
      private$..replace$curlyQuotes <- TRUE
      invisible(self)
    },

    keepCurlyQuotes = function() {
      private$..replace$curlyQuotes <- FALSE
      invisible(self)
    },

    replaceEmoji = function() {
      private$..replace$emoji <- TRUE
      invisible(self)
    },

    keepEmoji = function() {
      private$..replace$emoji <- FALSE
      invisible(self)
    },

    replaceEmoticon = function() {
      private$..replace$emoticon <- TRUE
      invisible(self)
    },

    keepEmoticon = function() {
      private$..replace$emoticon <- FALSE
      invisible(self)
    },

    replaceKern = function() {
      private$..replace$kern <- TRUE
      invisible(self)
    },

    keepKern = function() {
      private$..replace$kern <- FALSE
      invisible(self)
    },

    replaceNumbers = function() {
      private$..replace$numbers <- TRUE
      invisible(self)
    },

    keepNumeric = function() {
      private$..replace$numbers <- FALSE
      invisible(self)
    },

    replaceOrdinal = function() {
      private$..replace$ordinal <- TRUE
      invisible(self)
    },

    keepOrdinal = function() {
      private$..replace$ordinal <- FALSE
      invisible(self)
    },

    replaceSymbols = function() {
      private$..replace$symbols <- TRUE
      invisible(self)
    },

    keepSymbolForm = function() {
      private$..replace$symbols <- FALSE
      invisible(self)
    },

    replaceWordElongation = function() {
      private$..replace$wordElongation <- TRUE
      invisible(self)
    },

    keepWordElongation = function() {
      private$..replace$wordElongation <- FALSE
      invisible(self)
    },

    replaceWhiteSpace = function() {
      private$..replace$whiteSpace <- TRUE
      invisible(self)
    },

    addCommaSpace = function() {
      private$..add$commaSpace <- TRUE
      invisible(self)
    },

    selectAllReplace = function() {
      for (i in 1:length(private$..replace)) { private$..replace[[i]] <- TRUE }
      invisible(self)
    },

    selectAllRemove = function() {
      for (i in 1:length(private$..remove)) { private$..remove[[i]] <- TRUE }
      invisible(self)
    },

    selectAll = function() {
      private$..lowercase <- TRUE
      for (i in 1:length(private$..remove)) { private$..remove[[i]] <- TRUE }
      for (i in 1:length(private$..replace)) { private$..replace[[i]] <- TRUE }
      for (i in 1:length(private$..add)) { private$..add[[i]] <- TRUE }
      invisible(self)
    },

    resetAllReplace = function() {
      for (i in 1:length(private$..replace)) { private$..replace[[i]] <- FALSE }
      invisible(self)
    },

    resetAllRemove = function() {
      for (i in 1:length(private$..remove)) { private$..remove[[i]] <- FALSE }
      invisible(self)
    },

    resetAll = function() {
      private$..lowercase <- FALSE
      for (i in 1:length(private$..remove)) { private$..remove[[i]] <- FALSE }
      for (i in 1:length(private$..replace)) { private$..replace[[i]] <- FALSE }
      for (i in 1:length(private$..add)) { private$..add[[i]] <- FALSE }
      invisible(self)
    },

    #-------------------------------------------------------------------------#
    #                           Visitor Method                                #
    #-------------------------------------------------------------------------#
    accept = function(visitor)  {
      visitor$textConfig(self)
    }
  )
)