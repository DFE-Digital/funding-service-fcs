Feature: TableRow Extensions
	Tests for TableRow extension methods

@AcceptanceTest @Complete
Scenario: T009 Tooling - Create a type using TableRow.CreateInstance including an enum with spaces in the given value
	Given a TestType instance as follows
	| Prop1      | Prop2      | Enum             |
	| Prop1Value | Prop2Value | First Enum Value |
	Then the following values should be present in the instance
	| Prop1      | Prop2      | Enum           |
	| Prop1Value | Prop2Value | FirstEnumValue |

@AcceptanceTest @Complete
Scenario:  T010 Tooling - Compare a row to an instance using TableRow.CompareToInstance where empty strings and nulls are not be treated as equivalent
	Given a TestType instance with null values
	Then the following row should be equivalent to the instance when nulls and strings are not to be treated as equivalent
	| Prop1 | Prop2 |
	|   ?   |  ?    |

@AcceptanceTest @Complete
Scenario: T011 Tooling - Compare a row to an instance using TableRow.CompareToInstance where empty strings and nulls are be treated as equivalent
	Given a TestType instance with null values
	Then the following row should be equivalent to the instance when nulls and strings are to be treated as equivalent
	| Prop1 | Prop2 |
	|       |       |

@AcceptanceTest @Complete
Scenario: T012 Tooling - Ensure all styles of boolean literal can be parsed successfully
	Then the following boolean literals should be parsed as True
	| Value |
	| TRUE  |
	| True  |
	| true  |
	| YES   |
	| Yes   |
	| yes   |
	| 1     |
	And  the following boolean literals should be parsed as False
	| Value |
	| FALSE |
	| False |
	| false |
	| NO    |
	| No    |
	| no    |
	| 0     |
	And  the following boolean literals should be parsed as NULL
	| Value |
	| ?     |
