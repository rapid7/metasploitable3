# require 'rspec'
# require 'rspec/its'
# require_relative '../libraries/helpers_container'
#
# class FakeContainerForTestingImageProperty
#   include DockerCookbook::DockerHelpers::Container
#
#   def initialize(attributes = {})
#     @attributes = attributes
#   end
#
#   def repo(value = nil)
#     attributes['repo'] = value if value
#     attributes['repo']
#   end
#
#   def tag(value = nil)
#     attributes['tag'] = value if value
#     attributes['tag'] || 'latest'
#   end
#
#   private
#
#   attr_reader :attributes
# end
#
# describe DockerCookbook::DockerHelpers::Container do
#   let(:helper) { FakeContainerForTestingImageProperty.new }
#
#   describe '#image' do
#     subject { helper }
#
#     context "If you say: repo 'blah'" do
#       before { helper.repo 'blah' }
#       its(:image) { is_expected.to eq('blah:latest') }
#     end
#
#     context "If you say: repo 'blah'; tag '3.1'" do
#       before do
#         helper.repo 'blah'
#         helper.tag '3.1'
#       end
#       its(:image) { is_expected.to eq('blah:3.1') }
#     end
#
#     context "If you say: image 'blah'" do
#       before { helper.image 'blah' }
#       its(:repo) { is_expected.to eq('blah') }
#       its(:tag) { is_expected.to eq('latest') }
#     end
#
#     context "If you say: image 'blah:3.1'" do
#       before { helper.image 'blah:3.1' }
#       its(:repo) { is_expected.to eq('blah') }
#       its(:tag) { is_expected.to eq('3.1') }
#     end
#
#     context "If you say: image 'repo/blah'" do
#       before { helper.image 'repo/blah' }
#       its(:repo) { is_expected.to eq('repo/blah') }
#       its(:tag) { is_expected.to eq('latest') }
#     end
#
#     context "If you say: image 'repo/blah:3.1'" do
#       before { helper.image 'repo/blah:3.1' }
#       its(:repo) { is_expected.to eq('repo/blah') }
#       its(:tag) { is_expected.to eq('3.1') }
#     end
#
#     context "If you say: image 'repo:1337/blah'" do
#       before { helper.image 'repo:1337/blah' }
#       its(:repo) { is_expected.to eq('repo:1337/blah') }
#       its(:tag) { is_expected.to eq('latest') }
#     end
#
#     context "If you say: image 'repo:1337/blah:3.1'" do
#       before { helper.image 'repo:1337/blah:3.1' }
#       its(:repo) { is_expected.to eq('repo:1337/blah') }
#       its(:tag) { is_expected.to eq('3.1') }
#     end
#   end
# end
