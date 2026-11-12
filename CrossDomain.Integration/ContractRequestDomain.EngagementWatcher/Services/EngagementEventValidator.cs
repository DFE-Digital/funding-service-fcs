namespace SFA.FCT.ContractRequestDomain.EngagementWatcher.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;

    public static class EngagementEventValidator
    {
        private const string DasRsr001Message = "UKPRN is not specified";
        private const string DasRsr002Message = "UKPRN is not valid";

        public static void Validate(IEnumerable<EngagementEvent> engagementEvents)
        {
            engagementEvents.ToList().ForEach(engagementEvent =>
            {
                ValidationResult validationResult = GetValidationResult(engagementEvent);

                engagementEvent.IsValid = validationResult.IsValid;
                engagementEvent.ValidationError = validationResult.ValidationError;
            });
        }

        private static bool IsInitiatedEngagementEvent(EngagementEvent engagementEvent)
        {
            return engagementEvent.EventType == EngagementEvent.ValidEventType;
        }

        private static ValidationResult GetValidationResult(EngagementEvent engagementEvent)
        {
            string failureMessage = String.Empty;
            int providerId;
            if (string.IsNullOrEmpty(engagementEvent.ProviderId))
            {
                failureMessage = DasRsr001Message;
            }
            else if (!int.TryParse(engagementEvent.ProviderId, out providerId))
            {
                failureMessage = DasRsr002Message;
            }
            else if (!IsInitiatedEngagementEvent(engagementEvent))
            {
                failureMessage = $"The eventType is not valid - {engagementEvent.EventType}";
            }

            if (failureMessage != String.Empty)
            {
                failureMessage = $"{failureMessage} for DAS Engagement Event ID {engagementEvent.EventId}";
            }

            return new ValidationResult(failureMessage);
        }

        private class ValidationResult
        {
            public ValidationResult(string validationError)
            {
                ValidationError = validationError;
                IsValid = string.IsNullOrEmpty(ValidationError);
            }

            public string ValidationError { get; }

            public bool IsValid { get; }
        }
    }
}