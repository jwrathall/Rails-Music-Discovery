require_relative '../../lib/music_brainz'
require_relative  '../../lib/settings'


describe MusicBrainz do
  let(:musicbrainz){MusicBrainz.new}
  describe '#get_new_releases' do
    let(:json){ File.read(File.join('spec', 'fixtures', 'release_by_date.json'))}
    let(:date){'2014-03-18'}
    let(:data){MusicBrainz.get_new_releases date}
    let(:counts){:data['count']}
    it 'returns json' do
      count = '59'
      expect(count).to eq data
    end
  end
end