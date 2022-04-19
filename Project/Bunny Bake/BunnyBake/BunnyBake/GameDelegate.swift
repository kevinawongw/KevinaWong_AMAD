protocol GameDelegate {
  
  func updateMoney(by delta: Int) -> Bool
  func updateCrop(species: String)
  func save(dataFile: String)
  
}
