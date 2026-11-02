using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class ErrorQueueContract
    {
        public string QueueName { get; set; }
        public List<ErrorMessage> lstContract { get; set; }
    }

    public class ErrorMessage
    {
        public string MessageId { get; set; }
        public string MessageBody { get; set; }
        public DateTime CompleteDate { get; set; }
    }

    public class ErrorMessageIds
    {
        public string[] MessageIds { get; set; }
    }
}