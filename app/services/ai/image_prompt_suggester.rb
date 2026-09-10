module Ai
  class ImagePromptSuggester
    def initialize(post)
      @post = post
    end

    def call
      context = PostContextBuilder.new(@post).build
      prompt = SystemPrompts.image_prompt(context)

      response = Client.chat.ask(prompt)
      response.content.to_s.strip
    end
  end
end
