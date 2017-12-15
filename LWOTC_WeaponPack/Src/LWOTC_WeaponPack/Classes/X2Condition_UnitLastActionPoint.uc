//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_UnitLastActionPoint.uc
//  AUTHOR:  TauNeutrino
//  DATE:    14-Dec-2017
//  PURPOSE: Checks whether a unit is on its last action point. 
//  RETURNS: AA_Success if true and AA_Multiple_ActionPoints if false
//---------------------------------------------------------------------------------------

class X2Condition_UnitLastActionPoint extends X2Condition;

struct ActionPointCheck
{
	var name            ActionPointType;
	var bool            bCheckReserved;
	var CheckConfig     ConfigValue;
};
var() array<ActionPointCheck> m_aCheckValues;

function AddLastActionPointCheck(optional name Type=class'X2CharacterTemplateManager'.default.StandardActionPoint)
{
	local ActionPointCheck AddValue;
	AddValue.ActionPointType = Type;
	AddValue.ConfigValue.CheckType = eCheck_Exact;
	m_aCheckValues.AddItem(AddValue);
}

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;
	local name RetCode;
	local int i, NumPoints;

	RetCode = 'AA_Multiple_ActionPoints';
	UnitState = XComGameState_Unit(kTarget);
	if (UnitState != none )
	{
		if( UnitState.GetMyTemplate().bIsCosmetic ) //Cosmetic units are not limited by AP
		{
			RetCode = 'AA_Success';
		}
		else
		{
			for (i = 0; (i < m_aCheckValues.Length) && (RetCode != 'AA_Success'); ++i)
			{
				NumPoints = UnitState.NumActionPoints(m_aCheckValues[i].ActionPointType);
				RetCode = PerformValueCheck(NumPoints, m_aCheckValues[i].ConfigValue);
			}
		}
	}
	if (RetCode == 'AA_Success')
		return RetCode;

	return 'AA_Multiple_ActionPoints';   //  Change from value check error
}