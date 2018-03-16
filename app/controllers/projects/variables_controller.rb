class Projects::VariablesController < Projects::ApplicationController
  before_action :authorize_admin_build!

  def show
    respond_to do |format|
      format.json do
        render status: :ok, json: { variables: VariableSerializer.new.represent(@project.variables) }
      end
    end
  end

  def update
    if @project.update(variables_params)
      respond_to do |format|
        format.json { return render_variables }
      end
    else
      respond_to do |format|
        format.json { render_error }
      end
    end
  end

  private

  def render_variables
    render status: :ok, json: { variables: VariableSerializer.new.represent(@project.variables) }
  end

  def render_error
    render status: :bad_request, json: @project.errors.full_messages
  end

  def variables_params
    filtered_params = params.permit(variables_attributes: [*variable_params_attributes])
    filtered_params["variables_attributes"].each do |variable|
      variable["key"] = variable.delete("secret_key")
      variable["value"] = variable.delete("secret_value")
    end
    filtered_params
  end

  def variable_params_attributes
    %i[id secret_key secret_value protected _destroy]
  end
end
