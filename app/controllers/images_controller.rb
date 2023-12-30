class ImagesController < ApplicationController
    def new
        @image = Image.new
    end

    def create
        prompt = "purpose：書き初め風の画像を生成したい, detail：#{params[:image][:prompt]}, constraints：subtitles"
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

    def index
        @images = Image.all
    end

    private

    def image_params
        params.require(:image).permit(:image_url, :prompt)
    end
end
