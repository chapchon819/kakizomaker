class ChatgptService
    require 'openai'
    require 'httparty'
    require 'open-uri'


    def initialize
      @openai = OpenAI::Client.new(access_token: Rails.application.credentials[:chatgpt_api_key])
    end
  

    def chat(prompt)
      @client = OpenAI::Client.new(access_token: @api_key)
      response = @client.chat(
        parameters: {
          model: "gpt-3.5-turbo", # Required. # 使用するGPT-3のエンジンを指定
          messages: [{ role: "system", content: "translate into English." }, { role: "user", content: prompt }],
          temperature: 0.7, # 応答のランダム性を指定
          max_tokens: 200,  # 応答の長さを指定
        },
        )
      response['choices'].first['message']['content']
    end

    def set_token
      @api_key = Rails.application.credentials.dig(:openai, :api_key)
  end
  end

=begin
    def generate_image_with_dalle3(prompt)
      body = {
        model: "dall-e-3",
        prompt: "japanese calligraphy, #{prompt}",
        n: 1,
        size: "1024x1024"
        }
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{Rails.application.credentials[:chatgpt_api_key]}"
        }
      response = HTTParty.post("https://api.openai.com/v1/images/generations",
                             body: body.to_json,
                             headers: headers,
                             timeout: 100)
      raise response['error']['message'] unless response.code == 200
      response['data'][0]['url']
    end

    def self.download_image(prompt)
      service_instance = new
      image_url = service_instance.generate_image_with_dalle3(prompt)
      timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
      file_name = "#{timestamp}.png"
      file_path = Rails.root.join('public', 'generated_images', file_name)
      
      # 保存先ディレクトリがない場合は作成する
      FileUtils.mkdir_p(File.dirname(file_path))
  
      # 画像をダウンロードして保存
      URI.open(image_url) do |image|
        File.open(file_path, 'wb') do |file|
          file.write(image.read)
        end
      end
    end
  end
=end

