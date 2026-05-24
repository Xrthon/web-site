-- roles
insert into roles (code, title) values
('admin', 'admin'),
('business', 'business'),
('worker', 'worker'),
('user', 'user');

-- file_categories
insert into file_categories (code) values
('profile_image'),
('identity_document'),
('invoice'),
('ai_upload');

-- identity_verification_statuses
insert into identity_verification_statuses (code) values
('pending'),
('approved'),
('rejected'),
('expired');

-- identity_document_types
insert into identity_document_types (code) values
('passport'),
('driver_license'),
('residence_card'),
('national_identity_card');