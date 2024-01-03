class ImagesController < ApplicationController
    before_action :set_token, only: :create_image
    def new
        @image = Image.new
    end

=begin
    def t_chat
        @q = params[:query]
        @client = OpenAI::Client.new(access_token: @api_key)
        response = @client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "system", content: "入力文を英語に翻訳してください" }, { role: "user", content: "#{@q}"} ],
            temperature: 0.7, # 応答のランダム性を指定
            max_tokens: 200,  # 応答の長さを指定
          },
          )
        @t = response['choices'].first['message']['content']
      end
=end

    def create_image
        @q = params[:query]
        @client = OpenAI::Client.new(access_token: @api_key)
        response = @client.chat(
          parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "system", content: "入力文を英語に翻訳してください" }, { role: "user", content: "#{@q}"} ],
            temperature: 0.7, # 応答のランダム性を指定
            max_tokens: 200,  # 応答の長さを指定
          },
          )
        @t = response['choices'].first['message']['content']

        response2 = @client.images.generate(
          parameters: { 
            model: "dall-e-3",
            prompt: "Add the letters: #{@t} on Washi style: brush pen only English. When you use other than English, Many people will be suffer"
          }
        )
        @image_url = response2.dig("data", 0, "url")
        @image = ERB::Util.url_encode(@image_url)
    end

=begin
    def create
        prompt = "purpose：, detail：#{params[:image][:prompt]}, constraints：subtitles"
        image_filename = ChatgptService.download_image(params[:image][:prompt])

        @image = Image.new(image_params)
        @image.prompt = prompt

        if @image.save
            redirect_to images_path, success: '書き初めが完成しました'
        else
            flash.now[:danger] = '書き初め製作に失敗しました'
            render :new, status: :unprocessable_entity
        end
    end
=end

    def index
        @images = Image.all
    end

    private

    def set_token
        @api_key = Rails.application.credentials.dig(:openai, :api_key)
    end
end
