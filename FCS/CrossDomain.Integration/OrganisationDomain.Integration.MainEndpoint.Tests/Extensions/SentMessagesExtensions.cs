namespace OrganisationDomain.Integration.MainEndpoint.Tests.Extensions
{
    using System;
    using System.Linq;
    using NServiceBus.Testing;

    public static class SentMessagesExtensions
    {
        public static int Count<T>(this SentMessage<object>[] messages)
        {
            return messages.Select(m => m.Message).CastWhere<T>().Count();
        }

        public static int Count<T>(this SentMessage<object>[] messages, Func<T, bool> predicate)
        {
            return messages.Select(m => m.Message).CastWhere<T>().Count(predicate);
        }

        public static int Count<T>(this PublishedMessage<object>[] messages)
        {
            return messages.Select(m => m.Message).CastWhere<T>().Count();
        }
    }
}
