RSpec.shared_context "example create users and books" do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:book2) { create(:book) }
end