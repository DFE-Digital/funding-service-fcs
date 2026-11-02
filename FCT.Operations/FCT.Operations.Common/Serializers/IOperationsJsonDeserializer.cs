namespace SFA.FCT.Operations.Common.Serializers
{
    using System;

    public interface IOperationsJsonSerializer
    {
        object DeserializeJsonToObject(string jsonText, Type type);
    }
}
