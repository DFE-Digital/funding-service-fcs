using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.Xrm.Configuration.Tests.CriticalConfigurationValidation
{
     public class TransitionObject
    {
         public string Name { get; set; }
        public string ManagersTeam { get; set; }
        public string Owner { get; set; }
        public string ActionOnExistingTask { get; set; }
        public string FromAction { get; set; }
        public string NextAction { get; set; }
        public string FromState { get; set; }
        public string ToState { get; set; }
        public string ServiceIntent { get; set; }
        public string APICallRequired { get; set; }
        public string RequiresANotification { get; set; }
        public string RequiresChangeOfOwnership { get; set; }
        public string RequiresCreationOfTask { get; set; }
        public string Subject { get; set; }
        public string TaskDescription { get; set; }
        public string DefaultAssignTo { get; set; }
        public string NotificationType { get; set; }
        public string NotificationDescription { get; set; }
        public string NotificationSubject { get; set; }


    }
}
