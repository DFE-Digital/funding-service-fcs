---------- Instructions to generate C# class from .xsd -----------

Requirements
----------------
1. Visual Studio 2010/2013
2. xsd2code community edition

Settings
---------------
1. Expand Generic Base Class
	i. Set GenerateBaseClass = False
2. Expand Property Params 
	i. Set GeneratePropertyNameSpecified = None
3. Expand Serialization
	i. Set GenerateOrderXmlAttributes = True
	ii. Set GenerateXmlAttributes = True
4. Expand Code
	i. Set Namespace = SFA.FCT.CrossDomain.Integration.Entities
	ii. Set TargetFramework = Net40




All other settings are to be left as their defaut values.