require 'rails_helper'
describe PostsController do

  context 'normal user' do
    before do
      sign_in!
    end

    it 'allows user to create a post' do
      expect {
        post :create, params: { post: {content: "i love hats"}}
      }.to change(Post, :count).by(1)
    end

    it 'does not allow the user to update a post' do
      created_post = create(:post, content: 'bar')

      expect {
        post :update, params: { id: created_post.id, post: { content: 'foo' }}
      }.not_to change(created_post, :content)
    end

    it 'does not allow the user to delete a post' do
      created_post = create(:post, content: 'bar')

      expect {
        delete :destroy, params: { id: created_post.id }
      }.not_to change(Post, :count)
    end
  end

  context 'vip' do
    before do
      sign_in!('vip')
    end

    it 'allows user to create a post' do
      expect {
        post :create, params: { post: {content: "i love hats"}}
      }.to change(Post, :count).by(1)
    end

    it 'can update a post' do
      created_post = create(:post, content: 'bar')

      post :update, params: { id: created_post.id, post: { content: 'foo' }}

      expect(created_post.reload.content).to eq('foo')
    end

    it 'does not allow the user to delete a post' do
      created_post = create(:post, content: 'bar')

      expect {
        delete :destroy, params: { id: created_post.id }
      }.not_to change(Post, :count)
    end
  end

  context 'admin' do
    before do
      sign_in!('admin')
    end

    it 'allows user to create a post' do
      expect {
        post :create, params: { post: {content: "i love hats"}}
      }.to change(Post, :count).by(1)
    end

    it 'allows the user to update a post' do
      created_post = create(:post, content: 'bar')

      post :update, params: { id: created_post.id, post: { content: 'foo' }}

      expect(created_post.reload.content).to eq('foo')
    end

    it 'allows the user to delete a post' do
      created_post = create(:post, content: 'bar')

      expect {
        delete :destroy, params: { id: created_post.id }
      }.to change(Post, :count).by(-1)
    end
  end
end
