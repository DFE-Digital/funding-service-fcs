namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using NServiceBus;
    using SFA.FCS.Worker.Common;
    using SFA.FCT.CrossDomain.Integration.Events;

    public static class MessageDeferrer
    {
        private const int DeferralSeconds = 30;
        private const int MaxDeferrals = 40;

        public static async Task<bool> DeferEventIfNecessary(IMessageHandlerContext bus, IDeferrableEvent message, Func<bool> shouldDefer, Action actionIfNotDeferred, string prependedErrorMessage)
        {
            if (message.TimesMessageDeferred >= MaxDeferrals)
            {
                throw new ArgumentOutOfRangeException($"{prependedErrorMessage} - has been deferred the maximum of {MaxDeferrals} deferrals.");
            }

            if (shouldDefer())
            {
                message.TimesMessageDeferred++;

                object command = message;

                if (!IsACommand(message))
                {
                    command = (ICommand) DynamicTypeBuilder.BuildCommandFrom(message);
                }

                var sendOptions = new SendOptions();
                sendOptions.DelayDeliveryWith(TimeSpan.FromSeconds(DeferralSeconds));
                sendOptions.RouteToThisEndpoint();
                sendOptions.DoNotEnforceBestPractices();

                await bus.Send(command, sendOptions);

                return true;
            }
            actionIfNotDeferred();
            return false;
        }

        private static bool IsACommand(object message)
        {
            Type messageType = message.GetType();

            return (messageType.Namespace?.EndsWith("Commands") ?? false) // convention-based (False if Namespace is null)
                   || messageType.GetInterfaces().Contains(typeof (ICommand)); // dynamically generated type
        }
    }
}
