modifier_ignore_cast_angle = class({})

function modifier_ignore_cast_angle:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
    }
end

function modifier_ignore_cast_angle:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_ignore_cast_angle:IsHidden()
    return true
end

function modifier_ignore_cast_angle:IsPurgable()
    return false
end