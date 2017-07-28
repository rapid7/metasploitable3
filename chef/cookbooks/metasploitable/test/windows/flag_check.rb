control "flags-check" do
  title "Check flag locations"
  desc "Check if the flags are correctly placed"
  
  describe file('C:\\inetpub\\wwwroot\\six_of_diamonds.zip') do
   it { should exist }
  end

  describe file('C:\\WINDOWS\\System32\\jack_of_clubs.png') do
   it { should exist }
  end

  describe file('C:\\Windows\\three_of_spades.png') do
   it { should exist }
  end

  describe file('C:\\Windows\\System32\\kingofclubs.exe') do
   it { should exist }
  end

  describe file('C:\\Users\\Public\\Music\\four_of_clubs.wav') do
   it { should exist }
  end

  describe file('C:\\inetpub\\wwwroot\\index.html') do
   it { should exist }
  end

  describe file('C:\\inetpub\\wwwroot\\hahaha.jpg') do
   it { should exist }
  end

 describe file('C:\\inetpub\\wwwroot\\iisstart.htm') do
   it { should_not exist }
  end

  describe file('C:\\inetpub\\wwwroot\\seven_of_hearts.html') do
   it { should exist }
  end

  describe file('C:\\Users\\Public\\Documents\\jack_of_hearts.docx') do
   it { should exist }
  end

  describe file('C:\\Users\\Public\\Documents\\seven_of_spades.pdf') do
   it { should exist }
  end

  describe file('C:\\Users\\Public\\Pictures\\ace_of_hearts.jpg') do
   it { should exist }
  end

  describe file('C:\\Users\\Public\\Pictures\\ten_of_diamonds.png') do
   it { should exist }
  end

  describe file('C:\\jack_of_diamonds.png') do
   it { should exist }
  end

end
