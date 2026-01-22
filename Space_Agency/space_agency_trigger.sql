-- Trigger to keep a small record whenever a new budget entry is added
CREATE TABLE Budget_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT,
    amount DECIMAL(12,2),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_budget_log
AFTER INSERT ON Budgets
FOR EACH ROW
BEGIN
    -- Just storing basic info in log for tracking
    INSERT INTO Budget_Log (project_id, amount)
    VALUES (NEW.project_id, NEW.amount);
END;
//
DELIMITER ;
