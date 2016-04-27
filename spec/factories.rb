shared_context 'factories' do
  let(:user) do
    User.create(
      :name => 'Olivia Benson',
      :email => 'normal@user.com',
      :password => 'password',
      :role => 'volunteer'
    )
  end

  let(:admin) do
    User.create(
      :name => 'Carol Peletier',
      :email => 'admin@user.com',
      :password => 'password',
      :role => 'admin'
    )
  end

  let(:superadmin) do
    User.create(
      :name => 'Nene Leakes',
      :email => 'superadmin@user.com',
      :password => 'password',
      :role => 'superadmin'
    )
  end

  let(:facebook_id) do
    Identity.create(
      :uid => 'liara',
      :provider => 'facebook'
    )
  end

  let(:video) do
    allow(YoutubeReader).to receive(:parse_video).and_return(youtube_attributes)
    Video.create(
      :title => 'Factory-Created Video',
      :youtube_id => 'FavUpD_IjVY',
      :description => 'Factory-created description.'
    )
  end

  let(:translation) { Translation.create(:user => user, :video => video) }

  let(:youtube_attributes) do
    {
      'title' => 'Factory-Created Video',
      'description' => 'Factory-created description.',
      'duration' => '20'
    }
  end
end
