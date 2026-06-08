insert into client_need_statuses (code) values
('draft'),
('open'),
('closed'),
('cancelled');

insert into domain_categories (code) values
('construction'),
('technology'),
('automotive'),
('home_services'),
('health'),
('education');

insert into domains (domain_category_id, code) values
(1, 'electrical'),
(1, 'plumbing'),
(1, 'carpentry'),
(1, 'painting'),
(1, 'roofing'),
(1, 'masonry'),
(1, 'flooring'),
(1, 'drywall'),
(1, 'insulation'),
(1, 'excavation'),
(1, 'concrete'),
(1, 'demolition'),
(1, 'hvac'),
(1, 'doors_windows'),
(1, 'kitchen_renovation'),
(1, 'bathroom_renovation'),
(1, 'general_contractor');


insert into domains (domain_category_id, code) values
(2, 'web_development'),
(2, 'mobile_development'),
(2, 'desktop_development'),
(2, 'database_administration'),
(2, 'networking'),
(2, 'cybersecurity'),
(2, 'cloud_computing'),
(2, 'system_administration'),
(2, 'it_support'),
(2, 'artificial_intelligence'),
(2, 'automation'),
(2, 'data_analysis'),
(2, 'graphic_design'),
(2, 'ui_ux_design'),
(2, 'seo'),
(2, 'digital_marketing');

insert into domains (domain_category_id, code) values
(3, 'mechanical_repair'),
(3, 'bodywork'),
(3, 'painting'),
(3, 'tire_service'),
(3, 'oil_change'),
(3, 'diagnostics'),
(3, 'electrical_systems'),
(3, 'detailing'),
(3, 'windshield_repair'),
(3, 'vehicle_inspection');


insert into domains (domain_category_id, code) values
(4, 'house_cleaning'),
(4, 'window_cleaning'),
(4, 'pressure_washing'),
(4, 'lawn_care'),
(4, 'snow_removal'),
(4, 'tree_service'),
(4, 'moving'),
(4, 'junk_removal'),
(4, 'home_organization'),
(4, 'pest_control'),
(4, 'pool_maintenance'),
(4, 'pet_care'),
(4, 'house_sitting');

insert into domains (domain_category_id, code) values
(5, 'personal_training'),
(5, 'nutrition_coaching'),
(5, 'massage_therapy'),
(5, 'physiotherapy'),
(5, 'occupational_therapy'),
(5, 'mental_health_coaching'),
(5, 'yoga_instruction'),
(5, 'fitness_coaching');

insert into domains (domain_category_id, code) values
(6, 'academic_tutoring'),
(6, 'language_lessons'),
(6, 'music_lessons'),
(6, 'computer_training'),
(6, 'professional_coaching'),
(6, 'exam_preparation'),
(6, 'driving_lessons');

insert into service_location_types (code) values
('at_client_location'),
('remote'),
('at_provider_location'),
('hybrid'),
('pickup_and_delivery');
show indexes from domains;
SELECT *
from domain_categories;

alter table domains
drop index code;

alter table domains
add constraint uq_domains_category_code
unique (domain_category_id, code);