namespace SFA.FCT.Operations.DataStore.Repositories
{
    using System.Collections.Generic;
    using Model;

    public class MessageTypeBehaviourRepository : IMessageTypeBehaviourRepository
    {
        private readonly Dictionary<string, MessageTypeBehaviour> _messageTypeBehaviours = new Dictionary<string, MessageTypeBehaviour>
        {
            {
                "SFA.Common.Interfaces.Events.IOrganisationDetailsChanged", new MessageTypeBehaviour(MessageType.Event, "SFA.FCT.Operations.Common.DTOs.OrganisationDetailsChanged, FCT.Operations.Common")   
            },
            {
                "SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent", new MessageTypeBehaviour(MessageType.Event, "SFA.FCT.CrossDomain.Integration.Events.PaymentScheduleEvent")
            },
            {
                "SFA.FCT.CrossDomain.Integration.Events.PaymentAggregatedEvent", new MessageTypeBehaviour(MessageType.Event, "SFA.FCT.CrossDomain.Integration.Events.PaymentAggregatedEvent")
            }
        }; 

        public MessageTypeBehaviour GetBehaviourForMessageType(string messageTypeName)
        {
            MessageTypeBehaviour messageTypeBehaviour = null;

            if (_messageTypeBehaviours.ContainsKey(messageTypeName))
            {
                messageTypeBehaviour = _messageTypeBehaviours[messageTypeName];
            }

            return messageTypeBehaviour;
        }
    }
}
