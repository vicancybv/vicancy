require 'spec_helper'
require Rails.root.join('db', 'support', 'transform_users_into_resellers_migration')

describe TransformUsersIntoResellersMigration do
  let(:migration) { TransformUsersIntoResellersMigration.new }

  context 'new vicancy_reseller' do
    it 'should create vicancy reseller' do
      expect { migration.vicancy_reseller }.to change(Reseller, :count).by(1)
    end

    it 'created reseller should have slug' do
      expect(migration.vicancy_reseller.slug).to be_present
    end

    it 'created reseller should have token' do
      expect(migration.vicancy_reseller.token).to be_present
    end
  end

  context 'new vicancy_test_acc' do
    it 'should create vicancy test account' do
      expect { migration.vicancy_test_acc }.to change(Reseller, :count).by(1)
    end

    it 'created test account should have slug' do
      expect(migration.vicancy_test_acc.slug).to be_present
    end

    it 'created test account should have token' do
      expect(migration.vicancy_test_acc.token).to be_present
    end
  end

  context 'existing vicancy_reseller' do
    let(:reseller) { Reseller.create!(name: 'Vicancy', language: 'nl') }

    it 'should find vicancy reseller' do
      reseller
      new_reseller = migration.vicancy_reseller
      expect(new_reseller.id).to eq reseller.id
      expect(new_reseller.token).to eq reseller.token
      expect(new_reseller.slug).to eq reseller.slug
      expect(new_reseller.name).to eq reseller.name
      expect(new_reseller.language).to eq reseller.language
    end

    it 'should not create vicancy reseller' do
      reseller
      expect { migration.vicancy_reseller }.not_to change(Reseller, :count)
    end
  end

  context 'transform_user_into_client' do
    let(:user) {
      user = create(:user)
      user.videos.create!(attributes_for(:video))
      user.videos.create!(attributes_for(:video))
      user
    }
    let(:reseller) {
      Reseller.create!(name: 'Job Board', language: 'nl')
    }

    it 'should add client to reseller and copy user\'s attributes' do
      client = nil
      expect { client = migration.transform_user_into_client(user, reseller) }.to change(reseller.clients, :count).by(1)
      expect(client.reseller_id).to eq reseller.id
      expect(client.name).to eq user.name
      expect(client.slug).to eq user.slug
      expect(client.language).to eq user.language
      expect(client.token).to be_present
    end

    it 'should attach videos to client' do
      client = migration.transform_user_into_client(user, reseller)
      expect(client.videos.count).to eq 2
      expect(client.video_ids.sort).to eq user.video_ids.sort
    end
  end

  context 'user_is_reseller' do
    let(:user1) {
      user = create(:user)
      user.videos.create!(attributes_for(:video, company: 'C'))
      user.videos.create!(attributes_for(:video, company: 'C'))
      user
    }

    let(:user2) {
      user = create(:user)
      user.videos.create!(attributes_for(:video, title: 'V1', company: 'C1'))
      user.videos.create!(attributes_for(:video, title: 'V2', company: 'C2'))
      user
    }

    it 'should create reseller' do
      reseller = nil
      expect { reseller = migration.user_is_reseller(user1) }.to change(Reseller, :count).by(1)
      expect(reseller.name).to eq user1.name
      expect(reseller.slug).to eq user1.slug
      expect(reseller.language).to eq user1.language
    end

    context 'videos for the same company' do
      let(:reseller) { migration.user_is_reseller(user1) }
      it 'should create client for the reseller' do
        expect(reseller.clients.count).to eq 1
        client = reseller.clients.first
        expect(client.name).to eq 'C'
        expect(client.language).to eq 'es'
      end

      it 'should attach videos to the client' do
        client = reseller.clients.first
        expect(client.video_ids).to match_array user1.video_ids
      end
    end

    context 'videos for the different companies' do
      let(:reseller) { migration.user_is_reseller(user2) }

      it 'should create 2 clients for the reseller' do
        expect(reseller.clients.count).to eq 2
        client1 = reseller.clients.find_by_name('C1')
        client2 = reseller.clients.find_by_name('C2')
        expect(client1).to be_present
        expect(client2).to be_present
      end

      it 'should attach video to client 1' do
        client = reseller.clients.find_by_name('C1')
        expect(client.videos.pluck(:title)).to match_array ['V1']
      end

      it 'should attach video to client 2' do
        client = reseller.clients.find_by_name('C2')
        expect(client.videos.pluck(:title)).to match_array ['V2']
      end
    end

  end

  context 'run' do
    before(:each) do
      user = User.create!(name: 'U3', slug: 'u3')
      user.videos.create!(attributes_for(:video, company: 'C5'))
      user.videos.create!(attributes_for(:video, company: 'C6'))
      user = User.create!(name: 'U2', slug: 'u2')
      user.videos.create!(attributes_for(:video, company: 'C3'))
      user.videos.create!(attributes_for(:video, company: 'C4'))
      user = User.create!(name: 'U1', slug: 'u1')
      user.videos.create!(attributes_for(:video, company: 'C1'))
      user.videos.create!(attributes_for(:video, company: 'C2'))
      user = User.create!(name: 'U', slug: 'u')
      user.videos.create!(attributes_for(:video, company: 'C'))
      user.videos.create!(attributes_for(:video, company: 'C'))
      migration.reseller_names = ['U', 'U1']
      migration.test_names = ['U3']
    end

    let(:migration) { TransformUsersIntoResellersMigration.new }

    it 'should run and correcty transform' do
      migration.run

      # it should create vicancy client
      reseller = Reseller.find_by_name('Vicancy')
      expect(reseller).to be_present
      expect(reseller.slug).to be_present
      expect(reseller.token).to be_present
      client = reseller.clients.find_by_name('U2')
      expect(client).to be_present
      expect(client.slug).to eq 'u2'
      expect(client.token).to be_present
      expect(client.videos.pluck(:company)).to match_array ['C3','C4']

      # it should create vicancy test client
      reseller = Reseller.find_by_name('Vicancy (test)')
      expect(reseller).to be_present
      expect(reseller.slug).to be_present
      expect(reseller.token).to be_present
      client = reseller.clients.find_by_name('U3')
      expect(client).to be_present
      expect(client.slug).to eq 'u3'
      expect(client.token).to be_present
      expect(client.videos.pluck(:company)).to match_array ['C5','C6']

      # it should create reseller with 1 client
      reseller = Reseller.find_by_name('U')
      expect(reseller).to be_present
      expect(reseller.slug).to eq 'u'
      expect(reseller.clients.pluck(:name)).to match_array ['C']
      client = reseller.clients.find_by_name('C')
      expect(client).to be_present
      expect(client.slug).to be_present
      expect(client.token).to be_present
      expect(client.videos.pluck(:company)).to match_array ['C','C']

      # it should create reseller with 2 clients
      reseller = Reseller.find_by_name('U1')
      expect(reseller).to be_present
      expect(reseller.slug).to eq 'u1'
      expect(reseller.clients.pluck(:name)).to match_array ['C1', 'C2']
      client = reseller.clients.find_by_name('C1')
      expect(client).to be_present
      expect(client.slug).to be_present
      expect(client.token).to be_present
      expect(client.videos.pluck(:company)).to match_array ['C1']
      client = reseller.clients.find_by_name('C2')
      expect(client).to be_present
      expect(client.slug).to be_present
      expect(client.token).to be_present
      expect(client.videos.pluck(:company)).to match_array ['C2']
    end
  end
end