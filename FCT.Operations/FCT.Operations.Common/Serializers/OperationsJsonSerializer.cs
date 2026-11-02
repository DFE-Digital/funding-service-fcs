namespace SFA.FCT.Operations.Common.Serializers
{
    using System;    
    using Newtonsoft.Json;    

    public class OperationsJsonSerializer : IOperationsJsonSerializer
    {
        public object DeserializeJsonToObject(string jsonText, Type messageType)
        {
            var message = Activator.CreateInstance(messageType);
            JsonConvert.PopulateObject(jsonText, message);
            return message;   
        }
    }
}
