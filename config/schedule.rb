every 30.seconds do
  runner 'TrelloScannerWorker.perform_async'
end