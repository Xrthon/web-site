DELIMITER //

CREATE TRIGGER trg_user_roles_after_insert
AFTER INSERT ON user_roles
FOR EACH ROW
BEGIN
    INSERT INTO user_role_histories (
        user_id,
        old_role_id,
        new_role_id,
        changed_by,
        change_reason
    )
    VALUES (
        NEW.user_id,
        NULL,
        NEW.role_id,
        NULL,
        'ROLE_ASSIGNED'
    );
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_user_roles_after_update
AFTER UPDATE ON user_roles
FOR EACH ROW
BEGIN
    IF NOT (OLD.role_id <=> NEW.role_id) THEN
        INSERT INTO user_role_histories (
            user_id,
            old_role_id,
            new_role_id,
            changed_by,
            change_reason
        )
        VALUES (
            NEW.user_id,
            OLD.role_id,
            NEW.role_id,
            NULL,
            'ROLE_CHANGED'
        );
    END IF;
END//

DELIMITER ;