control 'apt::default' do
  describe file('/var/lib/apt/periodic/update-success-stamp') do
    it 'exists' do
      expect(subject).to exist
    end
  end
end
