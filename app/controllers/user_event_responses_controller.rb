class UserEventResponsesController < ApplicationController
    def create
        @user_event_response = current_user.user_event_response.build(user_event_response_params)
    end
    
    def update
        @event_response = UserEventResponse.where(:user_id => current_user.id, :event_id => response_params[:event_id]).first_or_initialize
        
        user_response = {user_id: current_user.id, event_id: response_params[:event_id], response_id: response_params[:response_id]}
            
        if @event_response.update_attributes(user_response)
            redirect_to root_url
        end
    end
    
    def destroy
        UserEventResponse.find(params[:id]).destroy
        redirect_to root_url
    end
    
    
    private
        def response_params
           params.require(:response).permit(:event_id, :response_id) 
        end
end
