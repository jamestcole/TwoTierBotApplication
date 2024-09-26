-- Create the finance_qa table
CREATE TABLE finance_qa (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique ID for each Q&A pair
    question TEXT NOT NULL,              -- Column to store the finance-related question
    answer TEXT NOT NULL                 -- Column to store the answer to the question
);

-- Insert some sample finance questions and answers
INSERT INTO finance_qa (question, answer) VALUES
('What is a stock?', 'A stock is a share in the ownership of a company, representing a claim on part of the company’s assets and earnings.'),
('What is a bond?', 'A bond is a fixed income instrument representing a loan made by an investor to a borrower, typically corporate or governmental.'),
('What is an index fund?', 'An index fund is a type of mutual fund or ETF designed to match or track the components of a financial market index.');

-- Example for selecting data from the table
SELECT * FROM finance_qa;
