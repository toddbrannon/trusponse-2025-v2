/*
  # Create survey submissions table

  1. New Tables
    - `survey_submissions`
      - `id` (uuid, primary key)
      - `created_at` (timestamp)
      - `name` (text)
      - `email` (text)
      - `phone` (text)
      - `company_name` (text)
      - `business_size` (text)
      - `services` (jsonb)
      - `budget` (text)
      - `timeframe` (text)
      - `existing_solutions` (text)
      - `contact_method` (text)
      - `project_description` (text)

  2. Security
    - Enable RLS on `survey_submissions` table
    - Add policy for authenticated users to insert data
    - Add policy for authenticated users to read their own submissions
*/

CREATE TABLE IF NOT EXISTS survey_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz DEFAULT now(),
  name text NOT NULL,
  email text NOT NULL,
  phone text,
  company_name text NOT NULL,
  business_size text,
  services jsonb NOT NULL DEFAULT '{}'::jsonb,
  budget text,
  timeframe text,
  existing_solutions text,
  contact_method text,
  project_description text
);

-- Enable Row Level Security
ALTER TABLE survey_submissions ENABLE ROW LEVEL SECURITY;

-- Allow any authenticated user to insert data
CREATE POLICY "Anyone can insert survey submissions"
  ON survey_submissions
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow users to read their own submissions based on email
CREATE POLICY "Users can read own submissions"
  ON survey_submissions
  FOR SELECT
  TO authenticated
  USING (email = auth.jwt()->>'email');