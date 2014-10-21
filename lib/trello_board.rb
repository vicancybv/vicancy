module TrelloBoard

  def list_by_name(name)
    board = Trello::Board.find(Settings.trello_board_id)
    board.lists.select { |list| list.name.downcase == name.downcase }.first
  end

  # Taking a description of the format:
  #
  # Some text
  # http://www.website.com/
  # Field: value
  # Field2: value2
  #
  # We want to end up with:
  # {field: "value", field2: "value2", unparseable: ["Some text","http://www.website.com/"]}
  def parse_card_description(card)
    CardDesc.new(card.desc)
  end

  def update_card_description(card, updates)
    parsed_description = parse_card_description(card)
    updates.each { |key, value| parsed_description[key] = value }
    card.desc = parsed_description.to_str
  end

  def extract_video_attachment_url(card)
    url = card.attachments.select { |a| a.name.split(".").last == "mp4" }.first.try(:url)
    url.try(:gsub, 'www.dropbox.com', 'dl.dropboxusercontent.com')
  end

  # Will not move lists, but still save, if list doesn't exist
  def move_to_list!(card, list_name)
    list_id = list_by_name(list_name).try(:id)
    card.list_id = list_id if list_id
    card.save
  end

  def processing_cards
    list_by_name("Processing").cards
  end

  def processing_card_for_video_id(id)
    processing_cards.select { |card| parse_card_description(card)[:id] == id.to_s }.first
  end

  def move_card_for_video_to_list(video_id, list_name)
    card = processing_card_for_video_id(video_id)
    move_to_list!(card, list_name) unless card.nil?
  end

  def already_imported_video(card)
    id = parse_card_description(card)[:id]
    return nil if id.blank?
    Video.find(id) rescue nil
  end

end