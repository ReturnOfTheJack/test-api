class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update]

  # Skip token verification.
  skip_before_action :verify_authenticity_token

  # Retrieves all students from API.
  def index
    respond_to do |format|
      format.html { @student = Student.all }
      format.json { render Student.all.to_json }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # Generating new objects via the API.
  def create
    require 'net/http'
    require 'json'

    student = Student.new(student_params)

    uri = URI('http://localhost:3000/students.json')

    request = Net::HTTP::Post.new uri, { 'Content-Type' => 'application/json' }
    # Appending the data to the request.
    request.body = student.to_json

    # Hitting the endpoint.
    response = Net::HTTP.start uri.hostname, uri.port do |http|
        http.request request
    end

    # If successful.
    if response.code == '200'
      redirect_to students_path, notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deleting data in the API.
  def destroy
    require 'net/http'
    require 'json'

    # Correct URL for deleting a resource.
    uri = URI("http://localhost:3000/students/#{params[:id]}.json")

    request = Net::HTTP::Delete.new uri

    # Hitting the endpoint.
    response = Net::HTTP.start uri.hostname, uri.port do |http|
        http.request request
    end

    if response.code == '200'
      redirect_to students_path, notice: 'Successfully removed record.'
    else
      redirect_to students_path, notice: 'Failed to delete.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:id, :name)
    end
end