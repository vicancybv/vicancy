module ResellersHelper

  def nav_class_for(c_name)
    active = false
    if c_name.is_a? Array
      active = !(c_name & [controller.action_name]).empty?
    else
      active = controller.action_name.include? c_name
    end
    if active
      'active'
    else
      ''
    end
  end

  def last_sign_in_at(client)
    if client.current_sign_in_at.present?
      dist = distance_of_time_in_words(client.current_sign_in_at, DateTime.now)
      t('date.ago', time: dist)
    else
      ''
    end
  end

  def vicancy_open(client)
    "vicancy.open({ clientId: \"#{j client.external_id }\", clientName: \"#{j client.name }\", "+
        "clientEmail: \"#{j client.email }\", clientLanguage: \"#{j client.get_language }\", "+
        "apiToken: \"#{j client.reseller.token }\"}); return false;"
  end
end
