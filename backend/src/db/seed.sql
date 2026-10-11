-- Insert Sample Series
INSERT INTO series (id, title, description, category) 
VALUES 
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'System Design Essentials', 'Master high-level architecture principles and scalability patterns.', 'System Design'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'Clean Code Principles', 'Learn best practices for writing maintainable and scalable code.', 'Software Engineering'),
  ('e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'DevOps & CI/CD Pipelines', 'Automate testing, deployment, and infrastructure management.', 'DevOps'),
  ('f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'Flutter & Mobile Architecture', 'Build fast, responsive mobile applications using modern state management.', 'Mobile')
ON CONFLICT DO NOTHING;

-- Insert Sample Daily Posts
INSERT INTO posts (id, series_id, title, content, category, read_time_minutes) 
VALUES 
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Understanding Load Balancers', 'Load balancing distributes incoming network traffic across multiple backend servers to ensure high availability and responsiveness...', 'System Design', 4),
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'SOLID: Single Responsibility', 'The Single Responsibility Principle (SRP) states that a class should have one, and only one, reason to change...', 'Software Engineering', 3),
  ('111ebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'Dockerizing Your Application', 'Containerization allows developers to package applications with all dependencies into standardized units for seamless deployment across environments...', 'DevOps', 5),
  ('222ebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 'CI/CD with GitHub Actions', 'Automate your software build, test, and deployment workflows using custom triggers and GitHub Actions runners...', 'DevOps', 4),
  ('333ebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 'Flutter State Management', 'Explore BLoC, Provider, and Riverpod patterns to manage complex application state cleanly in cross-platform apps...', 'Mobile', 6),
  ('444ebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 'Optimizing Mobile App Performance', 'Reduce app bundle size, eliminate frame drops, and optimize asynchronous operations for smooth 60fps rendering...', 'Mobile', 4),
  ('555ebc99-9c0b-4ef8-bb6d-6bb9bd380a05', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Database Sharding Strategies', 'Horizontal partitioning splits large databases into smaller, faster, and more manageable pieces called shards...', 'System Design', 5)
ON CONFLICT DO NOTHING;