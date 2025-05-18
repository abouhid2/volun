require "test_helper"

module Api
  module V1
    class ParticipantsControllerTest < ActionDispatch::IntegrationTest
      test "should create participant" do
        assert_difference('Participant.count') do
          post api_v1_event_participants_url(@event), params: { participant: { user_id: @user.id, status: "pending" } }
        end
        assert_response :created
      end

      test "should update participant" do
        patch api_v1_event_participant_url(@event, @participant), params: { participant: { status: "accepted" } }
        assert_response :success
      end

      test "should destroy participant" do
        assert_difference('Participant.count', -1) do
          delete api_v1_event_participant_url(@event, @participant)
        end
        assert_response :no_content
      end
    end
  end
end
