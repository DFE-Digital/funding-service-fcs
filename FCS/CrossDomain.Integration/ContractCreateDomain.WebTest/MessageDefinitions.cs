using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Web;
using NServiceBus;

namespace SFA.FCT.ContractCreateDomain.WebTest
{
    [ExcludeFromCodeCoverage]
    public class MessageDefinitions : INeedInitialization
    {
        void INeedInitialization.Customize(BusConfiguration configuration)
        {
            configuration.Conventions()
                .DefiningCommandsAs(
                    t =>
                        t.Namespace != null && t.Namespace.StartsWith("SFA.FCT.") &&
                        t.Name.EndsWith("Command"))
                .DefiningEventsAs(
                    t =>
                        t.Namespace != null && t.Namespace.StartsWith("SFA.FCT.") &&
                        t.Name.EndsWith("Event"));
        }
    }
}