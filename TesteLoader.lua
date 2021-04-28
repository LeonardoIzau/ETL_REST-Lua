extractor = require "Extractor"
transformer = require "Transformer"
loader = require "Loader"
vo = extractor.extract("RelExtraPorPeriodo.csv")
diasTrabalho = transformer.transform(vo)
loader.load(diasTrabalho)