# encoding: UTF-8

require 'spec_helper'

describe CardDesc do
  let(:desc1) { IO.read(Rails.root.join('spec','lib','desc1.txt')) }
  let(:desc2) { IO.read(Rails.root.join('spec','lib','desc2.txt')) }
  let(:desc3) { IO.read(Rails.root.join('spec','lib','desc3.txt')) }

  context 'write values' do
    it 'should change existing fields' do
      desc = CardDesc.new("Client:\nUrl: http://bit.ly/1w9Xohh")
      desc[:url] = 'http://1111'
      expect(desc.to_str).to eq "Client:\nUrl: http://1111"
    end

    it 'should change existing fields to multi-line' do
      desc = CardDesc.new("Client:\nUrl: http://bit.ly/1w9Xohh")
      desc[:url] = "http://1111\n!"
      expect(desc.to_str).to eq "Client:\nUrl: http://1111\n!"
    end

    it 'should add new fields' do
      desc = CardDesc.new("Client:\nUrl: http://bit.ly/1w9Xohh")
      desc[:id] = '112233'
      expect(desc.to_str).to eq "Client:\nUrl: http://bit.ly/1w9Xohh\nId: 112233"
    end

    it 'should add new fields with multi-line' do
      desc = CardDesc.new("Client:\nUrl: http://bit.ly/1w9Xohh")
      desc[:id] = "112233\n<html>"
      expect(desc.to_str).to eq "Client:\nUrl: http://bit.ly/1w9Xohh\nId: 112233\n<html>"
    end

    it 'should write field to empty desc' do
      desc = CardDesc.new('')
      desc[:id] = "112233"
      expect(desc.to_str).to eq "Id: 112233"
    end

  end

  context 'read values' do
    it 'should read values correctly' do
      desc = CardDesc.new(desc1)
      expect(desc[:client]).to be_nil
      expect(desc[:url]).to eq 'http://bit.ly/1w9Xohh'
      expect(desc[:editor]).to eq 'Frank'
      expect(desc[:music]).to eq 'Live my Life'
      expect(desc[:template]).to eq 'Vicancy 16.0 - Medical'
      expect(desc[:company]).to eq 'Sensire'
      expect(desc[:job_title]).to eq 'Verzorgende IG'
      expect(desc[:sub_title]).to eq 'Flexwerker in de Wijkzorg'
      expect(desc[:function_type]).to eq 'Flexcontract 0-16 uur'
      expect(desc[:field_i]).to eq 'Je werkt met ouderen, (chronisch) zieken of gehandicapte mensen'
      expect(desc[:field_ii]).to eq 'Je biedt ADL assistentie en doet verpleeg-technische handelingen'
      expect(desc[:field_iii]).to eq 'Je werkt zelfstandig en op je eigen manier'
      expect(desc[:place]).to eq 'Omgeving Varsseveld'
      expect(desc[:country]).to eq 'Nederland'
      expect(desc[:title_field]).to eq 'PROFIEL'
      expect(desc[:title_1]).to eq 'Opleiding'
      expect(desc[:field_1]).to eq 'Diploma Verzorgende IG (niveau 3), Ziekenverzorging of MDGO-VP'
      expect(desc[:title_2]).to eq 'Karakter'
      expect(desc[:field_2]).to eq 'Je bent geduldig en nauwkeurig, voelt je verantwoordelijk en werkt hard'
      expect(desc[:title_3]).to eq 'Competenties'
      expect(desc[:field_3]).to eq 'Je kunt goed samenwerken en stimuleert en motiveert zowel klanten als collega’s'
      expect(desc[:title_4]).to eq 'Taalvaardigheid'
      expect(desc[:field_4]).to eq 'Je kunt je zowel mondeling als schriftelijk goed uitdrukken'
      expect(desc[:button_text]).to eq 'Reageer nu'
      expect(desc[:tags]).to eq 'vacature, video, verzorgende, verzorging, thuiszorg, wijkzorg, betrokkenheid, Ziekenverzorging, assistentie, ondersteuning'
    end

    it 'should generate the same text back - desc1' do
      desc = CardDesc.new(desc1)
      expect(desc.to_str).to eq desc1.strip
    end

    it 'should generate the same text back - desc2' do
      desc = CardDesc.new(desc2)
      expect(desc.to_str).to eq desc2.strip
    end

    it 'should generate the same text back - desc3' do
      desc = CardDesc.new(desc3)
      expect(desc.to_str).to eq desc3.strip
    end
  end
end

describe CardDescLine do
  it 'should handle lines with empty values' do
    line = CardDescLine.new('Client:')
    expect(line.name).to be_nil
    expect(line.value).to be_nil
    expect(line.to_str).to eq 'Client:'
  end

  it 'should handle lines with normal values' do
    line = CardDescLine.new('Client: sometext goes here')
    expect(line.name).to eq :client
    expect(line.value).to eq 'sometext goes here'
    expect(line.to_str).to eq 'Client: sometext goes here'
  end

  it 'should handle lines with no values' do
    line = CardDescLine.new('Client sometext goes here')
    expect(line.name).to be_nil
    expect(line.value).to be_nil
    expect(line.to_str).to eq 'Client sometext goes here'
  end

  it 'should handle lines with no values - 2' do
    line = CardDescLine.new('### General')
    expect(line.name).to be_nil
    expect(line.value).to be_nil
    expect(line.to_str).to eq '### General'
  end

  it 'should handle empty lines' do
    line = CardDescLine.new('')
    expect(line.name).to be_nil
    expect(line.value).to be_nil
    expect(line.to_str).to eq ''
  end

  it 'should handle lines with http values' do
    line = CardDescLine.new('Url: http://bit.ly/1w9Xohh')
    expect(line.name).to eq :url
    expect(line.value).to eq 'http://bit.ly/1w9Xohh'
    expect(line.to_str).to eq 'Url: http://bit.ly/1w9Xohh'
  end

  it 'should handle lines ' do
    line = CardDescLine.new('Value: MY::GOOD:Value')
    expect(line.name).to eq :value
    expect(line.value).to eq 'MY::GOOD:Value'
    expect(line.to_str).to eq 'Value: MY::GOOD:Value'
  end

  it 'should handle multi-word names in lines ' do
    line = CardDescLine.new('Value 1: MY::GOOD:Value')
    expect(line.name).to eq :value_1
    expect(line.value).to eq 'MY::GOOD:Value'
    expect(line.to_str).to eq 'Value 1: MY::GOOD:Value'
  end

  it 'should handle lines with http urls (no values)' do
    line = CardDescLine.new('http://bit.ly/1w9Xohh')
    expect(line.name).to be_nil
    expect(line.value).to be_nil
    expect(line.to_str).to eq 'http://bit.ly/1w9Xohh'
  end

end