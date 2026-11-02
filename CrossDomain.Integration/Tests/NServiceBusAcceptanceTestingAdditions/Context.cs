namespace NServiceBusAcceptanceTestingAdditions
{
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Diagnostics.CodeAnalysis;
    using System.Linq;
    using System.Text;
    using Moq;
    using NServiceBus.AcceptanceTesting;
    using NServiceBus.Unicast.Subscriptions;

    [ExcludeFromCodeCoverage]
    public class Context : IDisposable
    {
        public class ContextData : ScenarioContext
        {
            private readonly ConcurrentDictionary<string, Mock> _mocks = new ConcurrentDictionary<string, Mock>();
            private readonly IList<string> _messageTypesRecieved = new List<string>();
            private readonly IList<string> _endpointsSubscribed = new List<string>();
            private readonly ConcurrentDictionary<string, bool> _flags = new ConcurrentDictionary<string, bool>();
            private readonly ConcurrentDictionary<string, object> _database = new ConcurrentDictionary<string, object>();
 
            public ConcurrentDictionary<string, Mock> Mocks
            {
                get { return _mocks; }
            }

            public IList<string> MessageTypesRecieved
            {
                get { return _messageTypesRecieved; }
            }

            public IList<string> EndpointsSubscribed
            {
                get { return _endpointsSubscribed; }
            }

            public ConcurrentDictionary<string, bool> Flags
            {
                get { return _flags; }
            }

            public ConcurrentDictionary<string, object> DataBase
            {
                get { return _database; }
            }
        }

        public Context() : this(new ContextData())
        {
        }

        public Context(ContextData data)
        {
            _contextData = data;
            ReadyToStart = ctx => true;
            AllDone = ctx => false;
            SubscriptionBehavior.OnEndpointSubscribed(OnEndpointSubscribed);
        }

        public Func<ContextData, bool> ReadyToStart { private get; set; }

        public Func<ContextData, bool> AllDone { private get; set; }

        public ContextData Data
        {
            get { return _contextData; }
        }

        public bool WasMessageOfTypeReceived<T>()
        {
            Type messageType = typeof(T);
            return messageType.IsInterface
                ? _contextData.MessageTypesRecieved.Any(s => s.Contains(messageType.Name))
                : _contextData.MessageTypesRecieved.Contains(messageType.AssemblyQualifiedName);
        }

        public bool IsAllDone
        {
            get { return AllDone != null && AllDone(_contextData); }
        }

        public bool IsReadyToStart
        {
            get { return ReadyToStart != null && ReadyToStart(_contextData); }
        }

        public void AddMock<T>(Mock<T> mock) where T : class
        {
            _contextData.Mocks.TryAdd(typeof(T).AssemblyQualifiedName, mock);
        }

        public Mock<T> GetMockOf<T>() where T : class
        {
            Mock mockToReturn = null;
            var typeName = typeof(T).Name;

            if (typeof(T).IsInterface)
            {
                if (_contextData.Mocks.Keys.Any(s => s.Contains(typeName)))
                {
                    mockToReturn = _contextData.Mocks.Where(kvp => kvp.Key.Contains(typeName)).Select(kvp => kvp.Value).FirstOrDefault();
                }
            }
            else
            {
                if (_contextData.Mocks.ContainsKey(typeName))
                {
                    mockToReturn = _contextData.Mocks[typeName];
                }
            }

            return mockToReturn as Mock<T>;
        }

        public void OnEndpointSubscribed(SubscriptionEventArgs s)
        {
            string subscription = s.SubscriberReturnAddress.Queue + " - " + s.MessageType;
            if (!_contextData.EndpointsSubscribed.Contains(subscription))
            {
                _contextData.EndpointsSubscribed.Add(subscription);
            }
        }

        public void OnMessageReceived(object message)
        {
            if (!_contextData.MessageTypesRecieved.Contains(message.GetType().AssemblyQualifiedName))
            {
                _contextData.MessageTypesRecieved.Add(message.GetType().AssemblyQualifiedName);
            }
        }

        public void AddOrUpdateFlag(string flagName, bool value)
        {
            _contextData.Flags.AddOrUpdate(flagName, value, (key, existingValue) => value);
        }

        #region private fields

        private readonly ContextData _contextData;

        #endregion

        public void Dispose()
        {
            SubscriptionBehavior.OnEndpointSubscribed(null);
        }
    }

    [ExcludeFromCodeCoverage]
    public static class ToStringExtensions
    {
        public static string ToString(this ConcurrentDictionary<string, bool> dict)
        {
            StringBuilder sb = new StringBuilder();
            foreach (KeyValuePair<string, bool> entry in dict)
            {
                sb.AppendFormat("{0} = {1}\n", entry.Key, entry.Value);
            }
            return sb.ToString();
        }
    }
}
