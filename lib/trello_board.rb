module TrelloBoard
  def list_by_name(name)
    board = Trello::Board.find(ENV['TRELLO_BOARD_ID'])
    board.lists.select{|list| list.name.downcase == name.downcase}.first
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
    parsed = {}
    parsed[:unparseable] = []
    card.desc.split("\n").each do |line|
      result = Hash[line.scan(/^(?!http)(.+)\s*:\s*(.+)$/i)]
      result.empty? ? parsed[:unparseable] << line : parsed.merge!(Hash[result.map{|k,v| [k.underscore.to_sym, v]}])
    end
    parsed
  end

  def update_card_description(card, updates)
    parsed_description = parse_card_description(card)
    updated_desc = parsed_description.except(:unparseable).merge(updates)
    updated_desc.delete_if{|k,v| v.blank?}
    updated_desc = updated_desc.map{|k,v| "#{k.to_s.titleize}: #{v}"}
    card.desc = parsed_description[:unparseable].concat(updated_desc).join("\n")
  end

  def extract_video_attachment_url(card)
    url = card.attachments.select{|a| a.name.split(".").last == "mp4"}.first.try(:url)
    url.gsub('www.dropbox.com', 'dl.dropboxusercontent.com')
  end


end